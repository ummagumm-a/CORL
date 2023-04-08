import gym
import d4rl
from algorithms.improved_td3_bc import ReplayBuffer
from sklearn.neighbors import NearestNeighbors

env = gym.make('hopper-medium-replay-v0')

state_dim = env.observation_space.shape[0]
action_dim = env.action_space.shape[0]

dataset = d4rl.qlearning_dataset(env)

replay_buffer = ReplayBuffer(
    state_dim,
    action_dim,
    int(2e6),
    "cpu",
)
replay_buffer.load_d4rl_dataset(dataset)

offline_ds_near_neigh = NearestNeighbors(n_neighbors=2)
offline_ds_near_neigh.fit(replay_buffer._states.cpu().numpy())

dist, _ = offline_ds_near_neigh.kneighbors(replay_buffer._states.cpu().numpy())
print(dist[:, 1].mean())
