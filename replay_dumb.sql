-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: improved_td3_bc_tune_replay
-- ------------------------------------------------------
-- Server version	8.0.32-0ubuntu0.20.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('v3.0.0.d');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `studies`
--

DROP TABLE IF EXISTS `studies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `studies` (
  `study_id` int NOT NULL AUTO_INCREMENT,
  `study_name` varchar(512) NOT NULL,
  PRIMARY KEY (`study_id`),
  UNIQUE KEY `ix_studies_study_name` (`study_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `studies`
--

LOCK TABLES `studies` WRITE;
/*!40000 ALTER TABLE `studies` DISABLE KEYS */;
INSERT INTO `studies` VALUES (1,'improved_td3_bc_tune_replay');
/*!40000 ALTER TABLE `studies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_directions`
--

DROP TABLE IF EXISTS `study_directions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_directions` (
  `study_direction_id` int NOT NULL AUTO_INCREMENT,
  `direction` enum('NOT_SET','MINIMIZE','MAXIMIZE') NOT NULL,
  `study_id` int NOT NULL,
  `objective` int NOT NULL,
  PRIMARY KEY (`study_direction_id`),
  UNIQUE KEY `study_id` (`study_id`,`objective`),
  CONSTRAINT `study_directions_ibfk_1` FOREIGN KEY (`study_id`) REFERENCES `studies` (`study_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_directions`
--

LOCK TABLES `study_directions` WRITE;
/*!40000 ALTER TABLE `study_directions` DISABLE KEYS */;
INSERT INTO `study_directions` VALUES (1,'MAXIMIZE',1,0),(2,'MAXIMIZE',1,1);
/*!40000 ALTER TABLE `study_directions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_system_attributes`
--

DROP TABLE IF EXISTS `study_system_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_system_attributes` (
  `study_system_attribute_id` int NOT NULL AUTO_INCREMENT,
  `study_id` int DEFAULT NULL,
  `key` varchar(512) DEFAULT NULL,
  `value_json` text,
  PRIMARY KEY (`study_system_attribute_id`),
  UNIQUE KEY `study_id` (`study_id`,`key`),
  CONSTRAINT `study_system_attributes_ibfk_1` FOREIGN KEY (`study_id`) REFERENCES `studies` (`study_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_system_attributes`
--

LOCK TABLES `study_system_attributes` WRITE;
/*!40000 ALTER TABLE `study_system_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_system_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_user_attributes`
--

DROP TABLE IF EXISTS `study_user_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_user_attributes` (
  `study_user_attribute_id` int NOT NULL AUTO_INCREMENT,
  `study_id` int DEFAULT NULL,
  `key` varchar(512) DEFAULT NULL,
  `value_json` text,
  PRIMARY KEY (`study_user_attribute_id`),
  UNIQUE KEY `study_id` (`study_id`,`key`),
  CONSTRAINT `study_user_attributes_ibfk_1` FOREIGN KEY (`study_id`) REFERENCES `studies` (`study_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_user_attributes`
--

LOCK TABLES `study_user_attributes` WRITE;
/*!40000 ALTER TABLE `study_user_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_user_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trial_heartbeats`
--

DROP TABLE IF EXISTS `trial_heartbeats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trial_heartbeats` (
  `trial_heartbeat_id` int NOT NULL AUTO_INCREMENT,
  `trial_id` int NOT NULL,
  `heartbeat` datetime NOT NULL,
  PRIMARY KEY (`trial_heartbeat_id`),
  UNIQUE KEY `trial_id` (`trial_id`),
  CONSTRAINT `trial_heartbeats_ibfk_1` FOREIGN KEY (`trial_id`) REFERENCES `trials` (`trial_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_heartbeats`
--

LOCK TABLES `trial_heartbeats` WRITE;
/*!40000 ALTER TABLE `trial_heartbeats` DISABLE KEYS */;
/*!40000 ALTER TABLE `trial_heartbeats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trial_intermediate_values`
--

DROP TABLE IF EXISTS `trial_intermediate_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trial_intermediate_values` (
  `trial_intermediate_value_id` int NOT NULL AUTO_INCREMENT,
  `trial_id` int NOT NULL,
  `step` int NOT NULL,
  `intermediate_value` double DEFAULT NULL,
  `intermediate_value_type` enum('FINITE','INF_POS','INF_NEG','NAN') NOT NULL,
  PRIMARY KEY (`trial_intermediate_value_id`),
  UNIQUE KEY `trial_id` (`trial_id`,`step`),
  CONSTRAINT `trial_intermediate_values_ibfk_1` FOREIGN KEY (`trial_id`) REFERENCES `trials` (`trial_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_intermediate_values`
--

LOCK TABLES `trial_intermediate_values` WRITE;
/*!40000 ALTER TABLE `trial_intermediate_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `trial_intermediate_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trial_params`
--

DROP TABLE IF EXISTS `trial_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trial_params` (
  `param_id` int NOT NULL AUTO_INCREMENT,
  `trial_id` int DEFAULT NULL,
  `param_name` varchar(512) DEFAULT NULL,
  `param_value` double DEFAULT NULL,
  `distribution_json` text,
  PRIMARY KEY (`param_id`),
  UNIQUE KEY `trial_id` (`trial_id`,`param_name`),
  CONSTRAINT `trial_params_ibfk_1` FOREIGN KEY (`trial_id`) REFERENCES `trials` (`trial_id`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_params`
--

LOCK TABLES `trial_params` WRITE;
/*!40000 ALTER TABLE `trial_params` DISABLE KEYS */;
INSERT INTO `trial_params` VALUES (1,1,'refinement_lambda',26.16183749125186,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(2,1,'expl_noise',0.6730810253934957,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(3,1,'alpha_start',2.1987282617045896,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(4,1,'alpha_end',1.8296133333525715,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.1987282617045896, \"log\": false}}'),(5,2,'refinement_lambda',22.19895081062012,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(6,2,'expl_noise',0.10225836339612782,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(7,2,'alpha_start',1.2304373075469333,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(8,2,'alpha_end',0.16841646843972916,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.2304373075469333, \"log\": false}}'),(9,3,'refinement_lambda',81.75833985372135,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(10,3,'expl_noise',0.7968348684096387,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(11,3,'alpha_start',1.570085730454346,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(12,3,'alpha_end',0.6690866585022911,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.570085730454346, \"log\": false}}'),(13,4,'refinement_lambda',52.09370785888026,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(14,4,'expl_noise',0.42834238273464675,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(15,4,'alpha_start',2.0133619180011904,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(16,4,'alpha_end',0.24020562966580467,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.0133619180011904, \"log\": false}}'),(17,5,'refinement_lambda',62.27109023814031,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(18,5,'expl_noise',0.9028820932800652,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(19,5,'alpha_start',1.4945757210436594,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(20,5,'alpha_end',0.16063822263542513,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.4945757210436594, \"log\": false}}'),(21,6,'refinement_lambda',18.71234473023781,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(22,6,'expl_noise',0.9860246365503073,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(23,6,'alpha_start',2.1096700258935424,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(24,6,'alpha_end',0.047656262168009264,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.1096700258935424, \"log\": false}}'),(25,7,'refinement_lambda',89.84674415741998,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(26,7,'expl_noise',0.9786531340425074,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(27,7,'alpha_start',2.433382420115155,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(28,7,'alpha_end',0.38640415971709574,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.433382420115155, \"log\": false}}'),(29,8,'refinement_lambda',73.46361294718858,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(30,8,'expl_noise',0.42147245357410046,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(31,8,'alpha_start',1.9265261159370448,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(32,8,'alpha_end',0.10292187616305554,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.9265261159370448, \"log\": false}}'),(33,9,'refinement_lambda',27.89973270439651,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(34,9,'expl_noise',0.16237846117188381,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(35,9,'alpha_start',0.9760038678644336,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(36,9,'alpha_end',0.7361089472663637,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.9760038678644336, \"log\": false}}'),(37,10,'refinement_lambda',58.635455569880605,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(38,10,'expl_noise',0.31350012999776444,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(39,10,'alpha_start',1.4088086750638835,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(40,10,'alpha_end',0.3095602768304858,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.4088086750638835, \"log\": false}}'),(41,11,'refinement_lambda',90.34713299370227,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(42,11,'expl_noise',0.057562309589584304,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(43,11,'alpha_start',2.1725854366018407,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(44,11,'alpha_end',0.9126504042589557,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.1725854366018407, \"log\": false}}'),(45,12,'refinement_lambda',45.64553402341147,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(46,12,'expl_noise',0.5688718238557243,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(47,12,'alpha_start',1.5086197065544842,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(48,12,'alpha_end',0.9423669392939473,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.5086197065544842, \"log\": false}}'),(49,13,'refinement_lambda',63.05042953245189,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(50,13,'expl_noise',0.6120092398477514,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(51,13,'alpha_start',2.463730171146401,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(52,13,'alpha_end',2.22788505892578,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.463730171146401, \"log\": false}}'),(53,14,'refinement_lambda',58.774753305044655,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(54,14,'expl_noise',0.6546959056721897,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(55,14,'alpha_start',1.8701550168400185,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(56,14,'alpha_end',0.8888424215158962,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.8701550168400185, \"log\": false}}'),(57,15,'refinement_lambda',56.07875925027593,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(58,15,'expl_noise',0.8480049776675204,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(59,15,'alpha_start',1.401302821474626,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(60,15,'alpha_end',0.9678477606414093,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.401302821474626, \"log\": false}}'),(61,16,'refinement_lambda',37.06190445688807,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(62,16,'expl_noise',0.8699794427428711,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(63,16,'alpha_start',1.8730086912477895,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(64,16,'alpha_end',0.3654936017371692,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.8730086912477895, \"log\": false}}'),(65,17,'refinement_lambda',51.12141068101963,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(66,17,'expl_noise',0.715017368810912,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(67,17,'alpha_start',1.6876685060105503,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(68,17,'alpha_end',0.938705914918501,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.6876685060105503, \"log\": false}}'),(69,18,'refinement_lambda',82.73159309559108,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(70,18,'expl_noise',0.17276740692752723,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(71,18,'alpha_start',1.8664546707100884,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(72,18,'alpha_end',0.17601006246588502,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.8664546707100884, \"log\": false}}'),(73,19,'refinement_lambda',24.456295521550686,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(74,19,'expl_noise',0.4672410082052597,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(75,19,'alpha_start',1.9246854333570484,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(76,19,'alpha_end',0.550023097521067,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.9246854333570484, \"log\": false}}'),(77,20,'refinement_lambda',77.91204880960142,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(78,20,'expl_noise',0.4037980440303559,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(79,20,'alpha_start',1.816767358757908,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(80,20,'alpha_end',1.6938226409603623,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.816767358757908, \"log\": false}}'),(81,21,'refinement_lambda',93.30190769662516,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(82,21,'expl_noise',0.07231911468457008,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(83,21,'alpha_start',0.25209683616886824,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(84,21,'alpha_end',0.004926502752224504,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.25209683616886824, \"log\": false}}'),(85,22,'refinement_lambda',95.38635871408952,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(86,22,'expl_noise',0.006560432701779986,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(87,22,'alpha_start',0.19359156059764326,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(88,22,'alpha_end',0.019609478373608533,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.19359156059764326, \"log\": false}}'),(89,23,'refinement_lambda',95.32727117825341,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(90,23,'expl_noise',0.00486601025716666,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(91,23,'alpha_start',0.22516537535699954,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(92,23,'alpha_end',0.06763267565625025,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.22516537535699954, \"log\": false}}'),(93,24,'refinement_lambda',95.16025583870781,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(94,24,'expl_noise',0.01628517695426035,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(95,24,'alpha_start',0.22231587812449605,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(96,24,'alpha_end',0.008766447044038297,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.22231587812449605, \"log\": false}}'),(97,25,'refinement_lambda',99.6879685291497,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(98,25,'expl_noise',0.00688852490515373,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(99,25,'alpha_start',0.13424657229824843,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(100,25,'alpha_end',0.01506037202409434,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.13424657229824843, \"log\": false}}'),(101,26,'refinement_lambda',99.86953758118217,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(102,26,'expl_noise',0.05122517076452631,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(103,26,'alpha_start',0.10659878034396164,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(104,26,'alpha_end',0.011092189572964442,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.10659878034396164, \"log\": false}}'),(105,27,'refinement_lambda',95.27102089448148,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(106,27,'expl_noise',0.010437790977892186,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(107,27,'alpha_start',0.18122642606328454,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(108,27,'alpha_end',0.004052711462450717,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.18122642606328454, \"log\": false}}'),(109,28,'refinement_lambda',11.674925588853199,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(110,28,'expl_noise',0.02093960149410201,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(111,28,'alpha_start',0.07433295502046056,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(112,28,'alpha_end',0.005898758594675965,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.07433295502046056, \"log\": false}}'),(113,29,'refinement_lambda',98.58248738729984,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(114,29,'expl_noise',0.005709210511432028,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(115,29,'alpha_start',0.00848670735115964,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(116,29,'alpha_end',1.7613211393749197,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.00848670735115964, \"log\": false}}'),(117,30,'refinement_lambda',99.57124329814648,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(118,30,'expl_noise',0.028696478163485396,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(119,30,'alpha_start',0.28584817374645266,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(120,30,'alpha_end',0.07953471402322326,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.28584817374645266, \"log\": false}}'),(121,31,'refinement_lambda',99.05139938229459,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(122,31,'expl_noise',0.019410809446856248,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(123,31,'alpha_start',2.2309079378942007,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(124,31,'alpha_end',1.2572794817787691,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.2309079378942007, \"log\": false}}'),(125,32,'refinement_lambda',99.1727890902877,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(126,32,'expl_noise',0.0007034829632237838,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(127,32,'alpha_start',0.38719680195201434,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(128,32,'alpha_end',0.0036003304483451237,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.38719680195201434, \"log\": false}}'),(129,33,'refinement_lambda',98.11826974237125,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(130,33,'expl_noise',0.21481597718807066,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(131,33,'alpha_start',0.7991741139369131,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(132,33,'alpha_end',0.07423286836192727,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.7991741139369131, \"log\": false}}'),(133,34,'refinement_lambda',72.54874640277463,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(134,34,'expl_noise',0.20191317142517362,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(135,34,'alpha_start',0.6559396493752319,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(136,34,'alpha_end',0.09981077476010716,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.6559396493752319, \"log\": false}}'),(137,35,'refinement_lambda',84.50609876780074,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(138,35,'expl_noise',0.22086197165219135,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(139,35,'alpha_start',0.6503272037821067,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(140,35,'alpha_end',0.0988134567270339,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.6503272037821067, \"log\": false}}'),(141,36,'refinement_lambda',70.22149525662954,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(142,36,'expl_noise',0.17725130311467863,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(143,36,'alpha_start',0.7932300881265071,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(144,36,'alpha_end',0.20635687031592717,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.7932300881265071, \"log\": false}}'),(145,37,'refinement_lambda',71.24687907004068,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(146,37,'expl_noise',0.19963436367288867,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(147,37,'alpha_start',0.7092829754123136,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(148,37,'alpha_end',0.12910108325864025,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.7092829754123136, \"log\": false}}'),(149,38,'refinement_lambda',0.9168915592826181,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(150,38,'expl_noise',0.1836284161611975,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(151,38,'alpha_start',0.5296189169571699,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(152,38,'alpha_end',0.06208189345708757,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.5296189169571699, \"log\": false}}'),(153,39,'refinement_lambda',70.57945150050901,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(154,39,'expl_noise',0.22227648778853668,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(155,39,'alpha_start',0.4861549649159904,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(156,39,'alpha_end',0.06020087154454434,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.4861549649159904, \"log\": false}}'),(157,40,'refinement_lambda',69.55458396356957,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(158,40,'expl_noise',0.2438780917902791,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(159,40,'alpha_start',0.445450175488336,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(160,40,'alpha_end',0.23445980229360752,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.445450175488336, \"log\": false}}'),(161,41,'refinement_lambda',69.15915707254925,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(162,41,'expl_noise',0.19501239894055356,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(163,41,'alpha_start',0.6839227793083567,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(164,41,'alpha_end',0.44552629653155806,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.6839227793083567, \"log\": false}}');
/*!40000 ALTER TABLE `trial_params` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trial_system_attributes`
--

DROP TABLE IF EXISTS `trial_system_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trial_system_attributes` (
  `trial_system_attribute_id` int NOT NULL AUTO_INCREMENT,
  `trial_id` int DEFAULT NULL,
  `key` varchar(512) DEFAULT NULL,
  `value_json` text,
  PRIMARY KEY (`trial_system_attribute_id`),
  UNIQUE KEY `trial_id` (`trial_id`,`key`),
  CONSTRAINT `trial_system_attributes_ibfk_1` FOREIGN KEY (`trial_id`) REFERENCES `trials` (`trial_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_system_attributes`
--

LOCK TABLES `trial_system_attributes` WRITE;
/*!40000 ALTER TABLE `trial_system_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `trial_system_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trial_user_attributes`
--

DROP TABLE IF EXISTS `trial_user_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trial_user_attributes` (
  `trial_user_attribute_id` int NOT NULL AUTO_INCREMENT,
  `trial_id` int DEFAULT NULL,
  `key` varchar(512) DEFAULT NULL,
  `value_json` text,
  PRIMARY KEY (`trial_user_attribute_id`),
  UNIQUE KEY `trial_id` (`trial_id`,`key`),
  CONSTRAINT `trial_user_attributes_ibfk_1` FOREIGN KEY (`trial_id`) REFERENCES `trials` (`trial_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_user_attributes`
--

LOCK TABLES `trial_user_attributes` WRITE;
/*!40000 ALTER TABLE `trial_user_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `trial_user_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trial_values`
--

DROP TABLE IF EXISTS `trial_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trial_values` (
  `trial_value_id` int NOT NULL AUTO_INCREMENT,
  `trial_id` int NOT NULL,
  `objective` int NOT NULL,
  `value` double DEFAULT NULL,
  `value_type` enum('FINITE','INF_POS','INF_NEG') NOT NULL,
  PRIMARY KEY (`trial_value_id`),
  UNIQUE KEY `trial_id` (`trial_id`,`objective`),
  CONSTRAINT `trial_values_ibfk_1` FOREIGN KEY (`trial_id`) REFERENCES `trials` (`trial_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_values`
--

LOCK TABLES `trial_values` WRITE;
/*!40000 ALTER TABLE `trial_values` DISABLE KEYS */;
INSERT INTO `trial_values` VALUES (1,1,0,72.64970416176388,'FINITE'),(2,1,1,-1038724.4874086299,'FINITE'),(3,3,0,95.95007719759403,'FINITE'),(4,3,1,-699819.1626509319,'FINITE'),(5,4,0,97.10149107104053,'FINITE'),(6,4,1,-397148.2499840128,'FINITE'),(7,5,0,95.82139795697924,'FINITE'),(8,5,1,-692035.7076772938,'FINITE'),(9,2,0,66.49995202620457,'FINITE'),(10,2,1,107368.80292646657,'FINITE'),(11,7,0,94.59098662698004,'FINITE'),(12,7,1,-752891.6549715595,'FINITE'),(13,9,0,74.45164650805336,'FINITE'),(14,9,1,-1783.0846319188845,'FINITE'),(15,10,0,96.05781296921923,'FINITE'),(16,10,1,-43490.50315351489,'FINITE'),(17,8,0,96.18510173265278,'FINITE'),(18,8,1,-144068.10118616495,'FINITE'),(19,11,0,93.23568707748538,'FINITE'),(20,11,1,357931.28444609896,'FINITE'),(21,12,0,95.16476854723264,'FINITE'),(22,12,1,-714221.1658420985,'FINITE'),(23,16,0,80.71268297571598,'FINITE'),(24,16,1,-877306.3639925474,'FINITE'),(25,15,0,96.96564591055257,'FINITE'),(26,15,1,-851711.8621727612,'FINITE'),(27,19,0,68.56358447745072,'FINITE'),(28,19,1,-683203.4281919062,'FINITE'),(29,14,0,95.91769256081828,'FINITE'),(30,14,1,-728874.6387018727,'FINITE'),(31,17,0,97.34708186275233,'FINITE'),(32,17,1,-796412.9346332941,'FINITE'),(33,13,0,96.05730343733364,'FINITE'),(34,13,1,-752690.7355321023,'FINITE'),(35,18,0,95.97755941307813,'FINITE'),(36,18,1,275414.4695724516,'FINITE'),(37,20,0,95.15418270659096,'FINITE'),(38,20,1,-313770.58641953894,'FINITE'),(39,21,0,94.178640293333,'FINITE'),(40,21,1,292697.81016951264,'FINITE'),(41,22,0,93.90434683276598,'FINITE'),(42,22,1,353069.13541577745,'FINITE'),(43,28,0,48.15368218088607,'FINITE'),(44,28,1,342839.6817488591,'FINITE'),(45,25,0,94.40540402579964,'FINITE'),(46,25,1,344618.24793151364,'FINITE'),(47,23,0,93.37497501986641,'FINITE'),(48,23,1,328832.1632898602,'FINITE'),(49,24,0,93.70031018504623,'FINITE'),(50,24,1,347112.8182573377,'FINITE'),(51,26,0,94.33288555172241,'FINITE'),(52,26,1,271933.98091752065,'FINITE'),(53,27,0,95.69857142401135,'FINITE'),(54,27,1,374294.60086396843,'FINITE'),(55,30,0,93.35415180218413,'FINITE'),(56,30,1,397246.9231738217,'FINITE'),(57,29,0,95.95485938412696,'FINITE'),(58,29,1,385701.1796481936,'FINITE'),(59,31,0,95.28786651449927,'FINITE'),(60,31,1,395271.2134974823,'FINITE'),(61,32,0,94.78603960813092,'FINITE'),(62,32,1,348002.3343266853,'FINITE'),(63,38,0,27.175090692888194,'FINITE'),(64,38,1,81446.14924284356,'FINITE'),(65,33,0,94.33285123058462,'FINITE'),(66,33,1,266753.69945397606,'FINITE'),(67,37,0,96.65179762328954,'FINITE'),(68,37,1,242086.73180338182,'FINITE'),(69,34,0,96.08752432711262,'FINITE'),(70,34,1,280479.4794340426,'FINITE'),(71,35,0,94.11396330500165,'FINITE'),(72,35,1,241906.98591192253,'FINITE'),(73,36,0,96.16328617993527,'FINITE'),(74,36,1,327016.8540118247,'FINITE'),(75,39,0,95.98255566854927,'FINITE'),(76,39,1,289939.79736173677,'FINITE'),(77,40,0,95.64917072472387,'FINITE'),(78,40,1,226194.72549095534,'FINITE'),(79,41,0,96.1858752203853,'FINITE'),(80,41,1,254278.02951915926,'FINITE');
/*!40000 ALTER TABLE `trial_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trials`
--

DROP TABLE IF EXISTS `trials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trials` (
  `trial_id` int NOT NULL AUTO_INCREMENT,
  `number` int DEFAULT NULL,
  `study_id` int DEFAULT NULL,
  `state` enum('RUNNING','COMPLETE','PRUNED','FAIL','WAITING') NOT NULL,
  `datetime_start` datetime DEFAULT NULL,
  `datetime_complete` datetime DEFAULT NULL,
  PRIMARY KEY (`trial_id`),
  KEY `study_id` (`study_id`),
  CONSTRAINT `trials_ibfk_1` FOREIGN KEY (`study_id`) REFERENCES `studies` (`study_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trials`
--

LOCK TABLES `trials` WRITE;
/*!40000 ALTER TABLE `trials` DISABLE KEYS */;
INSERT INTO `trials` VALUES (1,0,1,'COMPLETE','2023-04-07 21:09:36','2023-04-08 02:33:52'),(2,1,1,'COMPLETE','2023-04-07 21:09:37','2023-04-08 02:56:03'),(3,2,1,'COMPLETE','2023-04-07 21:09:37','2023-04-08 02:51:33'),(4,3,1,'COMPLETE','2023-04-07 21:09:38','2023-04-08 02:53:38'),(5,4,1,'COMPLETE','2023-04-07 21:09:39','2023-04-08 02:54:46'),(6,5,1,'FAIL','2023-04-07 21:17:13','2023-04-07 21:19:53'),(7,6,1,'COMPLETE','2023-04-07 21:20:58','2023-04-08 02:57:58'),(8,7,1,'COMPLETE','2023-04-07 21:21:02','2023-04-08 03:19:58'),(9,8,1,'COMPLETE','2023-04-07 21:21:03','2023-04-08 02:58:44'),(10,9,1,'COMPLETE','2023-04-07 21:21:03','2023-04-08 03:07:34'),(11,10,1,'COMPLETE','2023-04-07 21:21:04','2023-04-08 03:23:30'),(12,11,1,'COMPLETE','2023-04-08 02:33:52','2023-04-08 08:08:37'),(13,12,1,'COMPLETE','2023-04-08 02:51:33','2023-04-08 08:27:27'),(14,13,1,'COMPLETE','2023-04-08 02:53:38','2023-04-08 08:26:26'),(15,14,1,'COMPLETE','2023-04-08 02:54:46','2023-04-08 08:23:33'),(16,15,1,'COMPLETE','2023-04-08 02:56:03','2023-04-08 08:23:11'),(17,16,1,'COMPLETE','2023-04-08 02:57:58','2023-04-08 08:27:16'),(18,17,1,'COMPLETE','2023-04-08 02:58:44','2023-04-08 08:53:33'),(19,18,1,'COMPLETE','2023-04-08 03:07:34','2023-04-08 08:24:02'),(20,19,1,'COMPLETE','2023-04-08 03:19:59','2023-04-08 08:56:34'),(21,20,1,'COMPLETE','2023-04-08 03:23:30','2023-04-08 09:06:09'),(22,21,1,'COMPLETE','2023-04-08 08:08:37','2023-04-08 13:59:12'),(23,22,1,'COMPLETE','2023-04-08 08:23:11','2023-04-08 14:12:07'),(24,23,1,'COMPLETE','2023-04-08 08:23:33','2023-04-08 14:12:09'),(25,24,1,'COMPLETE','2023-04-08 08:24:02','2023-04-08 14:10:41'),(26,25,1,'COMPLETE','2023-04-08 08:26:26','2023-04-08 14:12:13'),(27,26,1,'COMPLETE','2023-04-08 08:27:16','2023-04-08 14:15:43'),(28,27,1,'COMPLETE','2023-04-08 08:27:27','2023-04-08 14:06:05'),(29,28,1,'COMPLETE','2023-04-08 08:53:33','2023-04-08 14:45:17'),(30,29,1,'COMPLETE','2023-04-08 08:56:34','2023-04-08 14:43:13'),(31,30,1,'COMPLETE','2023-04-08 09:06:09','2023-04-08 14:55:15'),(32,31,1,'COMPLETE','2023-04-08 13:59:12','2023-04-08 19:48:52'),(33,32,1,'COMPLETE','2023-04-08 14:06:06','2023-04-08 20:00:32'),(34,33,1,'COMPLETE','2023-04-08 14:10:41','2023-04-08 20:02:21'),(35,34,1,'COMPLETE','2023-04-08 14:12:07','2023-04-08 20:02:41'),(36,35,1,'COMPLETE','2023-04-08 14:12:09','2023-04-08 20:03:24'),(37,36,1,'COMPLETE','2023-04-08 14:12:13','2023-04-08 20:01:46'),(38,37,1,'COMPLETE','2023-04-08 14:15:43','2023-04-08 19:51:53'),(39,38,1,'COMPLETE','2023-04-08 14:43:13','2023-04-08 20:27:59'),(40,39,1,'COMPLETE','2023-04-08 14:45:17','2023-04-08 20:28:19'),(41,40,1,'COMPLETE','2023-04-08 14:55:15','2023-04-08 20:29:23');
/*!40000 ALTER TABLE `trials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `version_info`
--

DROP TABLE IF EXISTS `version_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `version_info` (
  `version_info_id` int NOT NULL,
  `schema_version` int DEFAULT NULL,
  `library_version` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`version_info_id`),
  CONSTRAINT `version_info_chk_1` CHECK ((`version_info_id` = 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `version_info`
--

LOCK TABLES `version_info` WRITE;
/*!40000 ALTER TABLE `version_info` DISABLE KEYS */;
INSERT INTO `version_info` VALUES (1,12,'3.1.1');
/*!40000 ALTER TABLE `version_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-08 20:45:49
