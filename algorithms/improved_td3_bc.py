# source: https://github.com/sfujim/TD3_BC
# https://arxiv.org/pdf/2106.06860.pdf
from typing import Any, Dict, List, Optional, Tuple, Union
import copy
from dataclasses import asdict, dataclass, replace
import os
from pathlib import Path
import random
import re
import uuid

import d4rl
import gym
import numpy as np
import optuna
import pyrallis
import tqdm
import torch
import torch.nn as nn
import torch.nn.functional as F
import wandb
from stable_baselines3.common.buffers import ReplayBuffer as sb3_ReplayBuffer
from sklearn.neighbors import NearestNeighbors

TensorBatch = List[torch.Tensor]


@dataclass
class TrainConfig:
    # Experiment
    device: str = "cuda"
    env: str = "hopper-medium-replay-v0"  # OpenAI gym environment name
    seed: int = 0  # Sets Gym, PyTorch and Numpy seeds
    eval_freq: int = int(1e4)  # How often (time steps) we evaluate
    n_episodes: int = 20  # How many episodes run during evaluation
#    max_timesteps: int = int(1e6)  # Max time steps to run environment
    max_timesteps: int = int(1e6)  # Max time steps to run environment
    checkpoints_path: Optional[str] = None  # Save path
    load_model: str = ""  # Model load file name, "" doesn't load
    # TD3
    buffer_size: int = 2_000_000  # Replay buffer size
    batch_size: int = 256  # Batch size for all networks
    discount: float = 0.99  # Discount ffor
    expl_noise: float = 0.1  # Std of Gaussian exploration noise
    tau: float = 0.005  # Target network update rate
    policy_noise: float = 0.2  # Noise added to target actor during critic update
    noise_clip: float = 0.5  # Range to clip target actor noise
    policy_freq: int = 2  # Frequency of delayed actor updates
    # TD3 + BC
    alpha: float = 2.5  # Coefficient for Q function in actor loss
    normalize: bool = True  # Normalize states
    normalize_reward: bool = False  # Normalize reward
    # Improved TD3 + BC
    refinement_lambda: float = 5
    refinement_timesteps: int = 100000
    alpha_start: float = 0.4
    alpha_end: float = 0.2
    buffer_collections_timesteps: int = 5000
    finetune_timesteps: int = 245000
    # Wandb logging
    project: str = "CORL"
    group: str = "IMPROVED_TD3_BC-D4RL_2.0"
    name: str = "IMPROVED_TD3_BC_2.0"
    job_type: str = "default"
    # Tuning
    hyper_tune: bool = False
    load_model_for_tune: str = None

    def __post_init__(self):
        self.name = f"{self.name}-{self.env}-{str(uuid.uuid4())[:8]}"
        if self.checkpoints_path is not None:
            self.checkpoints_path = os.path.join(self.checkpoints_path, self.name)


def soft_update(target: nn.Module, source: nn.Module, tau: float):
    for target_param, source_param in zip(target.parameters(), source.parameters()):
        target_param.data.copy_((1 - tau) * target_param.data + tau * source_param.data)


def compute_mean_std(states: np.ndarray, eps: float) -> Tuple[np.ndarray, np.ndarray]:
    mean = states.mean(0)
    std = states.std(0) + eps
    return mean, std


def normalize_states(states: np.ndarray, mean: np.ndarray, std: np.ndarray):
    return (states - mean) / std


def wrap_env(
    env: gym.Env,
    state_mean: Union[np.ndarray, float] = 0.0,
    state_std: Union[np.ndarray, float] = 1.0,
    reward_scale: float = 1.0,
) -> gym.Env:
    # PEP 8: E731 do not assign a lambda expression, use a def
    def normalize_state(state):
        return (
            state - state_mean
        ) / state_std  # epsilon should be already added in std.

    def scale_reward(reward):
        # Please be careful, here reward is multiplied by scale!
        return reward_scale * reward

    env = gym.wrappers.TransformObservation(env, normalize_state)
    if reward_scale != 1.0:
        env = gym.wrappers.TransformReward(env, scale_reward)
    return env


class ReplayBuffer:
    def __init__(
        self,
        state_dim: int,
        action_dim: int,
        buffer_size: int,
        device: str = "cpu",
    ):
        self._buffer_size = buffer_size
        self._pointer = 0
        self._size = 0

        self._states = torch.zeros(
            (buffer_size, state_dim), dtype=torch.float32, device=device
        )
        self._actions = torch.zeros(
            (buffer_size, action_dim), dtype=torch.float32, device=device
        )
        self._rewards = torch.zeros((buffer_size, 1), dtype=torch.float32, device=device)
        self._next_states = torch.zeros(
            (buffer_size, state_dim), dtype=torch.float32, device=device
        )
        self._dones = torch.zeros((buffer_size, 1), dtype=torch.float32, device=device)
        self._device = device

    def _to_tensor(self, data: np.ndarray) -> torch.Tensor:
        return torch.tensor(data, dtype=torch.float32, device=self._device)

    # Loads data in d4rl format, i.e. from Dict[str, np.array].
    def load_d4rl_dataset(self, data: Dict[str, np.ndarray]):
        if self._size != 0:
            raise ValueError("Trying to load data into non-empty replay buffer")
        n_transitions = data["observations"].shape[0]
        if n_transitions > self._buffer_size:
            raise ValueError(
                "Replay buffer is smaller than the dataset you are trying to load!"
            )
        self._states[:n_transitions] = self._to_tensor(data["observations"])
        self._actions[:n_transitions] = self._to_tensor(data["actions"])
        self._rewards[:n_transitions] = self._to_tensor(data["rewards"][..., None])
        self._next_states[:n_transitions] = self._to_tensor(data["next_observations"])
        self._dones[:n_transitions] = self._to_tensor(data["terminals"][..., None])
        self._size += n_transitions
        self._pointer = min(self._size, n_transitions)

        print(f"Dataset size: {n_transitions}")

    def sample(self, batch_size: int) -> TensorBatch:
        indices = np.random.randint(0, min(self._size, self._pointer), size=batch_size)
        states = self._states[indices]
        actions = self._actions[indices]
        rewards = self._rewards[indices]
        next_states = self._next_states[indices]
        dones = self._dones[indices]
        return [states, actions, rewards, next_states, dones]

    def add_transition(self):
        # Use this method to add new data into the replay buffer during fine-tuning.
        # I left it unimplemented since now we do not do fine-tuning.
        raise NotImplementedError


def set_seed(
    seed: int, env: Optional[gym.Env] = None, deterministic_torch: bool = False
):
    if env is not None:
        env.seed(seed)
        env.action_space.seed(seed)
    os.environ["PYTHONHASHSEED"] = str(seed)
    np.random.seed(seed)
    random.seed(seed)
    torch.manual_seed(seed)
    torch.use_deterministic_algorithms(deterministic_torch)


def wandb_init(config: dict) -> None:
    wandb.init(
        config=config,
        project=config["project"],
        group=config["group"],
        name=config["name"],
        job_type=config["job_type"],
        id=str(uuid.uuid4()),
    )
    wandb.run.save()


@torch.no_grad()
def eval_actor(
    env: gym.Env, actor: nn.Module, device: str, n_episodes: int, seed: int
) -> np.ndarray:
    env.seed(seed)
    actor.eval()
    episode_rewards = []
    episode_lengths = []
    for _ in range(n_episodes):
        state, done = env.reset(), False
        episode_reward = 0.0
        episode_length = 0
        while not done:
            action = actor.act(state, device)
            state, reward, done, _ = env.step(action)
            episode_reward += reward
            episode_length += 1
        episode_rewards.append(episode_reward)
        episode_lengths.append(episode_length)

    actor.train()
    return np.asarray(episode_rewards), np.asarray(episode_length)


def return_reward_range(dataset, max_episode_steps):
    returns, lengths = [], []
    ep_ret, ep_len = 0.0, 0
    for r, d in zip(dataset["rewards"], dataset["terminals"]):
        ep_ret += float(r)
        ep_len += 1
        if d or ep_len == max_episode_steps:
            returns.append(ep_ret)
            lengths.append(ep_len)
            ep_ret, ep_len = 0.0, 0
    lengths.append(ep_len)  # but still keep track of number of steps
    assert sum(lengths) == len(dataset["rewards"])
    return min(returns), max(returns)


def modify_reward(dataset, env_name, max_episode_steps=1000):
    if any(s in env_name for s in ("halfcheetah", "hopper", "walker2d")):
        min_ret, max_ret = return_reward_range(dataset, max_episode_steps)
        dataset["rewards"] /= max_ret - min_ret
        dataset["rewards"] *= max_episode_steps
    elif "antmaze" in env_name:
        dataset["rewards"] -= 1.0


class Actor(nn.Module):
    def __init__(self, state_dim: int, action_dim: int, max_action: float):
        super(Actor, self).__init__()

        self.net = nn.Sequential(
            nn.Linear(state_dim, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, action_dim),
            nn.Tanh(),
        )

        self.max_action = max_action

    def forward(self, state: torch.Tensor) -> torch.Tensor:
        return self.max_action * self.net(state)

    @torch.no_grad()
    def act(self, state: np.ndarray, device: str = "cpu") -> np.ndarray:
        state = torch.tensor(state.reshape(1, -1), device=device, dtype=torch.float32)
        return self(state).cpu().data.numpy().flatten()


class Critic(nn.Module):
    def __init__(self, state_dim: int, action_dim: int):
        super(Critic, self).__init__()

        self.net = nn.Sequential(
            nn.Linear(state_dim + action_dim, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 1),
        )

    def forward(self, state: torch.Tensor, action: torch.Tensor) -> torch.Tensor:
        sa = torch.cat([state, action], 1)
        return self.net(sa)


class TD3_BC:  # noqa
    def __init__(
        self,
        max_action: float,
        actor: nn.Module,
        actor_optimizer: torch.optim.Optimizer,
        critic_1: nn.Module,
        critic_1_optimizer: torch.optim.Optimizer,
        critic_2: nn.Module,
        critic_2_optimizer: torch.optim.Optimizer,
        discount: float = 0.99,
        tau: float = 0.005,
        policy_noise: float = 0.2,
        noise_clip: float = 0.5,
        policy_freq: int = 2,
        alpha: float = 2.5,
        device: str = "cpu",
        update_critic: bool = True
    ):
        self.actor = actor
        self.actor_target = copy.deepcopy(actor)
        self.actor_optimizer = actor_optimizer
        self.critic_1 = critic_1
        self.critic_1_target = copy.deepcopy(critic_1)
        self.critic_1_optimizer = critic_1_optimizer
        self.critic_2 = critic_2
        self.critic_2_target = copy.deepcopy(critic_2)
        self.critic_2_optimizer = critic_2_optimizer

        self.max_action = max_action
        self.discount = discount
        self.tau = tau
        self.policy_noise = policy_noise
        self.noise_clip = noise_clip
        self.policy_freq = policy_freq
        self.alpha = alpha

        self.total_it = 0
        self.device = device

        # The original paper reports that they don't update critic model
        # during refinement steps.
        # Therefore I added a flag to control this behaviour
        self.update_critic = update_critic

    def train(self, batch: TensorBatch, state_neighbors_dist: Optional[torch.tensor] = None, action_neighbors: Optional[torch.tensor] = None) -> Dict[str, float]:
        log_dict = {}
        self.total_it += 1

        state, action, reward, next_state, done = batch
        not_done = 1 - done

        with torch.no_grad():
            # Select action according to actor and add clipped noise
            noise = (torch.randn_like(action) * self.policy_noise).clamp(
                -self.noise_clip, self.noise_clip
            )

            next_action = (self.actor_target(next_state) + noise).clamp(
                -self.max_action, self.max_action
            )

            # Compute the target Q value
            target_q1 = self.critic_1_target(next_state, next_action)
            target_q2 = self.critic_2_target(next_state, next_action)
            target_q = torch.min(target_q1, target_q2)
            target_q = reward + not_done * self.discount * target_q

        # Get current Q estimates
        current_q1 = self.critic_1(state, action)
        current_q2 = self.critic_2(state, action)

        # Compute critic loss
        critic_loss = F.mse_loss(current_q1, target_q) + F.mse_loss(current_q2, target_q)
        log_dict["critic_loss"] = critic_loss.item()
        # Optimize the critic
        if self.update_critic:
            self.critic_1_optimizer.zero_grad()
            self.critic_2_optimizer.zero_grad()
            critic_loss.backward()
            self.critic_1_optimizer.step()
            self.critic_2_optimizer.step()

        # Delayed actor updates
        if self.total_it % self.policy_freq == 0:
            # Compute actor loss
            pi = self.actor(state)
            q = self.critic_1(state, pi)
#            lmbda = self.alpha / q.abs().mean().detach()

            penalty = F.mse_loss(pi, action)
            log_dict["penalty"] = penalty.item()
#            actor_loss = -lmbda * q.mean() + F.mse_loss(pi, action)
            actor_loss = -q.mean() / q.abs().mean().detach() + self.alpha * penalty
            log_dict["actor_loss"] = actor_loss.item()

            # Find divergence of chosen action 'pi' from actions in offline dataset
            if action_neighbors is not None and state_neighbors_dist is not None:
                penalty_offline = F.mse_loss(pi, action_neighbors.squeeze(1))
                log_dict["action_divergence_from_offline"] = penalty_offline.item()
                log_dict["state_divergence_from_offline"] = state_neighbors_dist.mean()

            # Optimize the actor
            self.actor_optimizer.zero_grad()
            actor_loss.backward()
            self.actor_optimizer.step()

            # Update the frozen target models
            soft_update(self.critic_1_target, self.critic_1, self.tau)
            soft_update(self.critic_2_target, self.critic_2, self.tau)
            soft_update(self.actor_target, self.actor, self.tau)

        return log_dict

    def state_dict(self) -> Dict[str, Any]:
        return {
            "critic_1": self.critic_1.state_dict(),
            "critic_1_optimizer": self.critic_1_optimizer.state_dict(),
            "critic_2": self.critic_2.state_dict(),
            "critic_2_optimizer": self.critic_2_optimizer.state_dict(),
            "actor": self.actor.state_dict(),
            "actor_optimizer": self.actor_optimizer.state_dict(),
            "total_it": self.total_it,
        }

    def load_state_dict(self, state_dict: Dict[str, Any]):
        self.critic_1.load_state_dict(state_dict["critic_1"])
        self.critic_1_optimizer.load_state_dict(state_dict["critic_1_optimizer"])
        self.critic_1_target = copy.deepcopy(self.critic_1)

        self.critic_2.load_state_dict(state_dict["critic_2"])
        self.critic_2_optimizer.load_state_dict(state_dict["critic_2_optimizer"])
        self.critic_2_target = copy.deepcopy(self.critic_2)

        self.actor.load_state_dict(state_dict["actor"])
        self.actor_optimizer.load_state_dict(state_dict["actor_optimizer"])
        self.actor_target = copy.deepcopy(self.actor)

        self.total_it = state_dict["total_it"]


def offline_train(config: TrainConfig, replay_buffer: ReplayBuffer, trainer: TD3_BC, env, mode: str, n_timesteps: int):
    evaluations = []
    for t in range(int(n_timesteps)):
        batch = replay_buffer.sample(config.batch_size)
        batch = [b.to(config.device) for b in batch]
        log_dict = trainer.train(batch)
        wandb.log({mode + "/": log_dict}, step=trainer.total_it)
        # Evaluate episode
        if (t + 1) % config.eval_freq == 0:
            print(f"Time steps: {t + 1}")
            eval_scores, eval_lengths = eval_actor(
                env,
                trainer.actor,
                device=config.device,
                n_episodes=config.n_episodes,
                seed=config.seed,
            )
            eval_score = eval_scores.mean()
            normalized_eval_score = env.get_normalized_score(eval_score) * 100.0
            evaluations.append(normalized_eval_score)
            print("---------------------------------------")
            print(
                f"Evaluation over {config.n_episodes} episodes: "
                f"{eval_score:.3f} , D4RL score: {normalized_eval_score:.3f}"
            )
            print("---------------------------------------")
            if config.checkpoints_path and (len(evaluations) == 1 or max(evaluations[:-1]) < normalized_eval_score):
                print("Saving")
                torch.save(
                    trainer.state_dict(),
                    os.path.join(config.checkpoints_path, f"best_checkpoint.pt"),
                )
                wandb.save(os.path.join(config.checkpoints_path, f"best_checkpoint.pt"))

            eval_log_dict = {
                   "d4rl_normalized_score": normalized_eval_score,
                   "eval_score_mean": eval_scores.mean(),
                   "eval_score_min": eval_scores.min(),
                   "eval_lengths_mean": eval_lengths.mean(),
                   "eval_lengths_min": eval_lengths.min(),
                }

            wandb.log({mode + "/": eval_log_dict}, step=trainer.total_it)

    return evaluations


def online_finetune(config: TrainConfig, env, replay_buffer: sb3_ReplayBuffer, trainer: TD3_BC, 
                    offline_ds_near_neigh: NearestNeighbors, offline_replay_buffer: ReplayBuffer, 
                    n_timesteps: int, mode: str, episode_num: int, decay_rate:float = None):
    state, done = env.reset(), False
    episode_reward = 0.0
    episode_length = 0
    evaluations = []
    training_rewards = []
    for i in tqdm.tqdm(range(n_timesteps), desc=mode):
        log = {}
        # The action is generated in the same way as in TD3_BC.train
        action = trainer.actor.act(state, device=config.device)
        noise = np.random.normal(0, scale=config.expl_noise, size=action.shape)
        noise = noise.clip(-trainer.noise_clip, trainer.noise_clip)
        action += noise
        action = action.clip(-trainer.max_action, trainer.max_action)

        next_state, reward, done, info = env.step(action)

        replay_buffer.add(state, next_state, action, reward, done, [info])

        state = next_state

        # Train
        if mode == "online_finetune":
            batch_ = replay_buffer.sample(config.batch_size)
            # This reodrering is for compatibility between ReplayBuffer in this file
            # and ReplayBuffer from stable_baselines3
            batch = batch_[0], batch_[1], batch_[4], batch_[2], batch_[3]
            batch = tuple(map(lambda x: x.to(torch.float32), batch))
            # Find states in the offline dataset which look like states from online replay buffer...
            state_neighbors_dist, state_neighbors_inds = offline_ds_near_neigh.kneighbors(batch[0].cpu().numpy())
            # ... and also get corresponding actions
            action_neighbors = offline_replay_buffer._actions[state_neighbors_inds]
            # Make a training step
            log_dict = trainer.train(batch, state_neighbors_dist, action_neighbors)
            log_dict["alpha"] = trainer.alpha
            log.update(log_dict)

            trainer.alpha *= decay_rate

            # Evaluate episode
            if (i + 1) % config.eval_freq == 0:
                print(f"Time steps: {i + 1}")
                eval_scores, eval_lengths = eval_actor(
                    env,
                    trainer.actor,
                    device=config.device,
                    n_episodes=config.n_episodes,
                    seed=config.seed,
                )
                eval_score = eval_scores.mean()
                normalized_eval_score = env.get_normalized_score(eval_score) * 100.0
                evaluations.append(normalized_eval_score)
                print("---------------------------------------")
                print(
                    f"Evaluation over {config.n_episodes} episodes: "
                    f"{eval_score:.3f} , D4RL score: {normalized_eval_score:.3f}"
                )
                print("---------------------------------------")
                if config.checkpoints_path and len(evaluations) != 1 and max(evaluations) < normalized_eval_score:
                    torch.save(
                        trainer.state_dict(),
                        os.path.join(config.checkpoints_path, f"best_checkpoint.pt"),
                    )
                    wandb.save(os.path.join(config.checkpoints_path, f"best_checkpoint.pt"))

                log.update({
                       "d4rl_normalized_score": normalized_eval_score,
                       "eval_score_mean": eval_scores.mean(),
                       "eval_score_min": eval_scores.min(),
                       "eval_lengths_mean": eval_lengths.mean(),
                       "eval_lengths_min": eval_lengths.min(),
                    })


        # For logging
        episode_reward += reward
        episode_length += 1

        if done:
            state, done = env.reset(), False
            # If done - log info about current episode to wandb
            # and reset counters
            log.update({
                     "train_episode_score": episode_reward,
                     "train_episode_length": episode_length,
                   })
#            episode_reward = env.get_normalized_score(episode_reward) * 100
            training_rewards.append(episode_reward)
            episode_reward = 0.0 
            episode_length = 0
            episode_num += 1

        if len(log) != 0:
            wandb.log({mode + "/": log})

    return episode_num, training_rewards


def train_helper(config: TrainConfig):
    env = gym.make(config.env)

    state_dim = env.observation_space.shape[0]
    action_dim = env.action_space.shape[0]

    dataset = d4rl.qlearning_dataset(env)

    if config.normalize_reward:
        modify_reward(dataset, config.env)

    if config.normalize:
        state_mean, state_std = compute_mean_std(dataset["observations"], eps=1e-3)
    else:
        state_mean, state_std = 0, 1

    dataset["observations"] = normalize_states(
        dataset["observations"], state_mean, state_std
    )
    dataset["next_observations"] = normalize_states(
        dataset["next_observations"], state_mean, state_std
    )
    env = wrap_env(env, state_mean=state_mean, state_std=state_std)
    replay_buffer = ReplayBuffer(
        state_dim,
        action_dim,
        config.buffer_size,
        config.device,
    )
    replay_buffer.load_d4rl_dataset(dataset)

    max_action = float(env.action_space.high[0])

    if config.checkpoints_path is not None:
        print(f"Checkpoints path: {config.checkpoints_path}")
        os.makedirs(config.checkpoints_path, exist_ok=True)
        with open(os.path.join(config.checkpoints_path, "config.yaml"), "w") as f:
            pyrallis.dump(config, f)

    # Set seeds
    seed = config.seed
    set_seed(seed, env)

    actor = Actor(state_dim, action_dim, max_action).to(config.device)
    actor_optimizer = torch.optim.Adam(actor.parameters(), lr=3e-4)

    critic_1 = Critic(state_dim, action_dim).to(config.device)
    critic_1_optimizer = torch.optim.Adam(critic_1.parameters(), lr=3e-4)
    critic_2 = Critic(state_dim, action_dim).to(config.device)
    critic_2_optimizer = torch.optim.Adam(critic_2.parameters(), lr=3e-4)

    kwargs = {
        "max_action": max_action,
        "actor": actor,
        "actor_optimizer": actor_optimizer,
        "critic_1": critic_1,
        "critic_1_optimizer": critic_1_optimizer,
        "critic_2": critic_2,
        "critic_2_optimizer": critic_2_optimizer,
        "discount": config.discount,
        "tau": config.tau,
        "device": config.device,
        # TD3
        "policy_noise": config.policy_noise * max_action,
        "noise_clip": config.noise_clip * max_action,
        "policy_freq": config.policy_freq,
        # TD3 + BC
        "alpha": config.alpha,
    }

    print("---------------------------------------")
    print(f"Training TD3 + BC, Env: {config.env}, Seed: {seed}")
    print("---------------------------------------")

    wandb_init(asdict(config))
    # Initialize actor
    trainer = TD3_BC(**kwargs)

    if config.load_model != "":
        print("Load model, do not train from scratch")
        policy_file = Path(config.load_model)
        trainer.load_state_dict(torch.load(policy_file))
    else:
        # To speed up experiments I train a model only once, save its weights
        # and then just reuse it in further steps

        # Offline Training
        offline_evaluations = offline_train(config, replay_buffer, trainer, env, 'offline_training', config.max_timesteps)
        # If the best model is saved during training - take it.
        # Not sure, it may be a good engeneering decision, but the original paper does not mention such trick.
        # Thus, it may be safer to not use it
#        if config.checkpoints_path:
#            policy_file = Path(config.load_model)
#            trainer.load_state_dict(torch.load(policy_file))

    initial_scores, _ = eval_actor(
        env,
        trainer.actor,
        device=config.device,
        n_episodes=config.n_episodes, # for more reliability
        seed=config.seed,
    )
    initial_score = initial_scores.mean()


    # Policy Refinement
    trainer.alpha /= config.refinement_lambda
    trainer.update_critic = False
    refinement_evaluations = offline_train(config, replay_buffer, trainer, env, 'offline_refinement', config.refinement_timesteps)

    trainer.update_critic = True
    # We don't want to divide on zero
    if config.alpha_start == 0 or config.finetune_timesteps == 0:
        decay_rate = 0
    else:
        decay_rate = np.exp(np.log(config.alpha_end / config.alpha_start) / config.finetune_timesteps)
    print("decay_rate", decay_rate)
    trainer.alpha = config.alpha_start

    online_replay_buffer = sb3_ReplayBuffer(
            config.buffer_size,
            env.observation_space,
            env.action_space,
            config.device,
            handle_timeout_termination=True
            )

    # Fit nearest neighbors
    print("Constructing NearestNeighbors")
    offline_ds_near_neigh = NearestNeighbors(n_neighbors=1)
    offline_ds_near_neigh.fit(replay_buffer._states.cpu().numpy())

    # Initialize Buffer with 'buffer_collections_timesteps' timesteps
    episode_num, buffer_collection_rewards = online_finetune(config, env, online_replay_buffer, trainer, offline_ds_near_neigh, replay_buffer, config.buffer_collections_timesteps, "buffer_collection", episode_num=0)
    buffer_collection_rewards = np.asarray(buffer_collection_rewards)

    # See the proximity of states in the initialized buffer to the states visited by the behaviour policy
    init_states_dist, _ = offline_ds_near_neigh.kneighbors(online_replay_buffer.observations[:, 0, :])
    wandb.run.summary["init_states_dist_mean"] = init_states_dist.mean()
    wandb.run.summary["init_states_dist_std"] = init_states_dist.std()

    # Finetune online with data collected from interactions with the environment
    episode_num, finetune_rewards = online_finetune(config, env, online_replay_buffer, trainer, offline_ds_near_neigh, replay_buffer, config.finetune_timesteps, "online_finetune", episode_num=episode_num, decay_rate=decay_rate)
    finetune_rewards = np.asarray(finetune_rewards)

    wandb.finish()

    all_rewards = np.hstack((buffer_collection_rewards, finetune_rewards))
    all_rewards -= initial_score

    return refinement_evaluations, np.sum(all_rewards)


class Objective:
    def __init__(self, config, num_seeds):
        self.config = config
        self.num_seeds = num_seeds

    def __call__(self, trial):
        new_config = replace(self.config)
        new_config.refinement_lambda = trial.suggest_float("refinement_lambda", 0.5, 100)
        new_config.expl_noise = trial.suggest_float("expl_noise", 0, 1)
        new_config.alpha_start = trial.suggest_float("alpha_start", 0, self.config.alpha)
        new_config.alpha_end = trial.suggest_float("alpha_end", 0, new_config.alpha_start)

        refinements = []
        finetune_values = []
        for i in range(self.num_seeds):
            new_config.seed = i
            new_config.load_model = next(filter(lambda x: (f"pretrained_seed{i+1}-" + self.config.env) in x, os.listdir(self.config.load_model_for_tune)))
            new_config.load_model = os.path.join(self.config.load_model_for_tune, new_config.load_model, "best_checkpoint.pt")
            new_config.name = f"r_{new_config.refinement_lambda}_e_{new_config.expl_noise}_as_{new_config.alpha_start}_ae_{new_config.alpha_end}_seed_{i}"
            
            refienement_evaluations, value = train_helper(new_config)

            finetune_values.append(value)
            refinements.append(refienement_evaluations)

        refinements = np.asarray(refinements)
        
        return refinements.mean(axis=0).max(), sum(finetune_values) / len(finetune_values)


@pyrallis.wrap()
def train(config: TrainConfig):
    if config.hyper_tune:
        if "expert" in config.env:
            study = optuna.load_study(study_name="improved_td3_bc_tune_expert", storage="mysql://root@localhost/improved_td3_bc_tune_expert")
        elif "replay" in config.env:
            study = optuna.load_study(study_name="improved_td3_bc_tune_replay", storage="mysql://root@localhost/improved_td3_bc_tune_replay")
        else:
            raise Exception(f"Cannot tune for {config.env}")

        study.optimize(Objective(config, num_seeds=5), n_trials=4)
    else:    
        return train_helper(config)

if __name__ == "__main__":
    train()
