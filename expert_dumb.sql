-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: improved_td3_bc_tune_expert
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
INSERT INTO `studies` VALUES (1,'improved_td3_bc_tune_expert');
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
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trial_params`
--

LOCK TABLES `trial_params` WRITE;
/*!40000 ALTER TABLE `trial_params` DISABLE KEYS */;
INSERT INTO `trial_params` VALUES (1,1,'refinement_lambda',11.258007477979286,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(2,1,'expl_noise',0.2186503341531859,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(3,1,'alpha_start',1.8035246584714149,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(4,1,'alpha_end',0.5955139324617851,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.8035246584714149, \"log\": false}}'),(5,2,'refinement_lambda',30.683887815877352,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(6,2,'expl_noise',0.17551999072909907,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(7,2,'alpha_start',1.138892997209461,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(8,2,'alpha_end',0.05550557703322717,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.138892997209461, \"log\": false}}'),(9,3,'refinement_lambda',80.73691133521737,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(10,3,'expl_noise',0.7091217277093318,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(11,3,'alpha_start',1.6726919472995148,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(12,3,'alpha_end',0.20567390336022195,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.6726919472995148, \"log\": false}}'),(13,4,'refinement_lambda',29.806442633266354,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(14,4,'expl_noise',0.6448685530344036,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(15,4,'alpha_start',2.4016487298377758,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(16,4,'alpha_end',1.1778442242348093,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.4016487298377758, \"log\": false}}'),(17,5,'refinement_lambda',42.853288898617684,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(18,5,'expl_noise',0.29317590957077133,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(19,5,'alpha_start',0.8899534224950554,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(20,5,'alpha_end',0.6986859129108747,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.8899534224950554, \"log\": false}}'),(21,6,'refinement_lambda',50.49866123340518,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(22,6,'expl_noise',0.9071584366197556,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(23,6,'alpha_start',0.06144666108128222,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(24,6,'alpha_end',0.008920856417783507,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.06144666108128222, \"log\": false}}'),(25,7,'refinement_lambda',1.6898109272068103,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(26,7,'expl_noise',0.2408105861593588,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(27,7,'alpha_start',2.4783071433598876,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(28,7,'alpha_end',2.0774635029777455,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.4783071433598876, \"log\": false}}'),(29,8,'refinement_lambda',71.75491756824876,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(30,8,'expl_noise',0.9506612573696774,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(31,8,'alpha_start',1.0310368986701757,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(32,8,'alpha_end',1.0183620796868023,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0310368986701757, \"log\": false}}'),(33,9,'refinement_lambda',8.847159555507977,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(34,9,'expl_noise',0.7910365367008168,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(35,9,'alpha_start',0.5948979586537682,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(36,9,'alpha_end',0.3620752315368921,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.5948979586537682, \"log\": false}}'),(37,10,'refinement_lambda',42.92301525858311,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(38,10,'expl_noise',0.5572666308670022,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(39,10,'alpha_start',0.6295176193408856,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(40,10,'alpha_end',0.24940265260928554,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.6295176193408856, \"log\": false}}'),(41,11,'refinement_lambda',53.49874539688012,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(42,11,'expl_noise',0.896429360073274,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(43,11,'alpha_start',2.4612668350317817,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(44,11,'alpha_end',1.376861122287538,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.4612668350317817, \"log\": false}}'),(45,12,'refinement_lambda',64.57202273034206,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(46,12,'expl_noise',0.28093716025282456,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(47,12,'alpha_start',0.8453511483967193,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(48,12,'alpha_end',0.6364374309147434,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.8453511483967193, \"log\": false}}'),(49,13,'refinement_lambda',36.19293797794711,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(50,13,'expl_noise',0.6816230739807893,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(51,13,'alpha_start',0.8080926259576147,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(52,13,'alpha_end',0.7118937951450461,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.8080926259576147, \"log\": false}}'),(53,14,'refinement_lambda',74.77327714668917,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(54,14,'expl_noise',0.3996633881859688,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(55,14,'alpha_start',0.635499565116783,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(56,14,'alpha_end',0.5670347206030397,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.635499565116783, \"log\": false}}'),(57,15,'refinement_lambda',6.379409142890489,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(58,15,'expl_noise',0.5970244738809397,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(59,15,'alpha_start',0.9392375706857023,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(60,15,'alpha_end',0.7746029569960098,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.9392375706857023, \"log\": false}}'),(61,16,'refinement_lambda',4.958766556728011,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(62,16,'expl_noise',0.45704426075685833,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(63,16,'alpha_start',1.7675858631236554,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(64,16,'alpha_end',0.14150633433956375,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.7675858631236554, \"log\": false}}'),(65,17,'refinement_lambda',0.8739507201584648,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(66,17,'expl_noise',0.06536542259280409,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(67,17,'alpha_start',1.7683308629284848,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(68,17,'alpha_end',1.0389203519123908,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.7683308629284848, \"log\": false}}'),(69,18,'refinement_lambda',37.18901537357321,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(70,18,'expl_noise',0.46044819219670874,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(71,18,'alpha_start',1.4368249447529788,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(72,18,'alpha_end',0.3531248117298902,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.4368249447529788, \"log\": false}}'),(73,19,'refinement_lambda',97.49111566400681,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(74,19,'expl_noise',0.9371737061155011,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(75,19,'alpha_start',0.31666444195618676,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(76,19,'alpha_end',0.31232672727240196,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 0.31666444195618676, \"log\": false}}'),(77,20,'refinement_lambda',18.925399822810515,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(78,20,'expl_noise',0.4199873124569063,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(79,20,'alpha_start',1.7000385443629333,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(80,20,'alpha_end',0.57562974869377,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.7000385443629333, \"log\": false}}'),(81,21,'refinement_lambda',17.571110882375613,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(82,21,'expl_noise',0.0032817266403298573,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(83,21,'alpha_start',1.561225448766796,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(84,21,'alpha_end',0.49000239936162177,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.561225448766796, \"log\": false}}'),(85,22,'refinement_lambda',99.05078695407096,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(86,22,'expl_noise',0.01979155519275555,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(87,22,'alpha_start',1.531760975189029,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(88,22,'alpha_end',0.012525663084992922,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.531760975189029, \"log\": false}}'),(89,23,'refinement_lambda',20.253117289475878,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(90,23,'expl_noise',0.011579744775229828,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(91,23,'alpha_start',1.5142615058633275,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(92,23,'alpha_end',0.02948102475698322,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.5142615058633275, \"log\": false}}'),(93,24,'refinement_lambda',22.532183603291706,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(94,24,'expl_noise',0.026726939714325826,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(95,24,'alpha_start',1.4413030997295875,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(96,24,'alpha_end',0.014386704049938283,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.4413030997295875, \"log\": false}}'),(97,25,'refinement_lambda',97.54624370240882,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(98,25,'expl_noise',0.05505284664470095,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(99,25,'alpha_start',1.3964804128003503,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(100,25,'alpha_end',0.08171638766754176,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.3964804128003503, \"log\": false}}'),(101,26,'refinement_lambda',21.764622843657293,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(102,26,'expl_noise',0.046684160570725164,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(103,26,'alpha_start',1.3869990041529845,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(104,26,'alpha_end',0.012438061820378217,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.3869990041529845, \"log\": false}}'),(105,27,'refinement_lambda',23.284383123384522,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(106,27,'expl_noise',0.037808845730058493,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(107,27,'alpha_start',1.3432234191620045,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(108,27,'alpha_end',0.042982654539072976,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.3432234191620045, \"log\": false}}'),(109,28,'refinement_lambda',21.453424943657467,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(110,28,'expl_noise',0.04937507268349606,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(111,28,'alpha_start',1.2504836922961102,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(112,28,'alpha_end',0.001016369124288638,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.2504836922961102, \"log\": false}}'),(113,29,'refinement_lambda',23.416975075373436,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(114,29,'expl_noise',0.01568464926570795,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(115,29,'alpha_start',1.2398393433069201,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(116,29,'alpha_end',0.053766017713149594,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.2398393433069201, \"log\": false}}'),(117,30,'refinement_lambda',17.204749327751845,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(118,30,'expl_noise',0.000921327153451057,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(119,30,'alpha_start',2.159890669879296,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(120,30,'alpha_end',1.3948891044559208,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.159890669879296, \"log\": false}}'),(121,31,'refinement_lambda',17.556501004832473,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(122,31,'expl_noise',0.027699190950572494,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(123,31,'alpha_start',2.013704263025879,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(124,31,'alpha_end',0.9355669413430967,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.013704263025879, \"log\": false}}'),(125,32,'refinement_lambda',17.903571225040793,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(126,32,'expl_noise',0.1269374821640416,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(127,32,'alpha_start',2.050982904405552,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(128,32,'alpha_end',0.9440881546920724,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.050982904405552, \"log\": false}}'),(129,33,'refinement_lambda',19.29443997782638,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(130,33,'expl_noise',0.13253157280717706,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(131,33,'alpha_start',2.0614978344768247,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(132,33,'alpha_end',0.45214878522760216,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.0614978344768247, \"log\": false}}'),(133,34,'refinement_lambda',18.301911671285364,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(134,34,'expl_noise',0.1324596339390018,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(135,34,'alpha_start',1.2192776200376743,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(136,34,'alpha_end',0.45417701208399536,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.2192776200376743, \"log\": false}}'),(137,35,'refinement_lambda',21.11172448806591,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(138,35,'expl_noise',0.1253171853165159,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(139,35,'alpha_start',1.2651646143394464,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(140,35,'alpha_end',0.45742126215434553,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.2651646143394464, \"log\": false}}'),(141,36,'refinement_lambda',15.024791514858011,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(142,36,'expl_noise',0.12178409659397235,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(143,36,'alpha_start',2.0236953318107727,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(144,36,'alpha_end',0.4459448436742055,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.0236953318107727, \"log\": false}}'),(145,37,'refinement_lambda',15.035686406392175,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(146,37,'expl_noise',0.1281029817790788,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(147,37,'alpha_start',1.1320246870216828,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(148,37,'alpha_end',0.4599047186229699,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.1320246870216828, \"log\": false}}'),(149,38,'refinement_lambda',11.331754624799078,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(150,38,'expl_noise',0.14546381783069853,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(151,38,'alpha_start',1.941422073380014,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(152,38,'alpha_end',0.45706905259364217,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.941422073380014, \"log\": false}}'),(153,39,'refinement_lambda',12.706059633290515,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(154,39,'expl_noise',0.14795594898653702,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(155,39,'alpha_start',2.0096950835026557,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(156,39,'alpha_end',0.47811536840307367,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.0096950835026557, \"log\": false}}'),(157,40,'refinement_lambda',14.265256829948807,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.5, \"high\": 100.0, \"log\": false}}'),(158,40,'expl_noise',0.1337582767716539,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 1.0, \"log\": false}}'),(159,40,'alpha_start',2.06361257040908,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.5, \"log\": false}}'),(160,40,'alpha_end',1.5497975878180976,'{\"name\": \"FloatDistribution\", \"attributes\": {\"step\": null, \"low\": 0.0, \"high\": 2.06361257040908, \"log\": false}}');
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
INSERT INTO `trial_values` VALUES (1,8,0,42.856411336448666,'FINITE'),(2,8,1,-3869799.725639818,'FINITE'),(3,3,0,42.04550903618913,'FINITE'),(4,3,1,-3395587.0180744426,'FINITE'),(5,4,0,112.59185445018502,'FINITE'),(6,4,1,-4105258.325985079,'FINITE'),(7,10,0,90.28354088334561,'FINITE'),(8,10,1,-2951037.032971228,'FINITE'),(9,5,0,92.9119133500711,'FINITE'),(10,5,1,-1985260.6839600306,'FINITE'),(11,6,0,73.94337518234843,'FINITE'),(12,6,1,-2696440.3569029574,'FINITE'),(13,7,0,98.86048449657171,'FINITE'),(14,7,1,-2319478.3898274386,'FINITE'),(15,9,0,112.28431398064382,'FINITE'),(16,9,1,-3268065.6914827847,'FINITE'),(17,2,0,107.20339126271915,'FINITE'),(18,2,1,-935555.6320287827,'FINITE'),(19,1,0,112.59052859744266,'FINITE'),(20,1,1,-1576477.8597754617,'FINITE'),(21,11,0,62.81752721510098,'FINITE'),(22,11,1,-4228104.292282265,'FINITE'),(23,14,0,41.96582320356931,'FINITE'),(24,14,1,-2466562.544093988,'FINITE'),(25,12,0,55.959450744215246,'FINITE'),(26,12,1,-1981624.8078211416,'FINITE'),(27,13,0,102.88764139765155,'FINITE'),(28,13,1,-3377157.992591406,'FINITE'),(29,15,0,112.28681049612344,'FINITE'),(30,15,1,-3360086.033444314,'FINITE'),(31,19,0,44.370344770916454,'FINITE'),(32,19,1,-3195935.112385648,'FINITE'),(33,18,0,101.25338791753855,'FINITE'),(34,18,1,-2875118.8355023544,'FINITE'),(35,16,0,112.34548608682398,'FINITE'),(36,16,1,-2844840.6992063224,'FINITE'),(37,20,0,112.76244840681882,'FINITE'),(38,20,1,-3028533.082282646,'FINITE'),(39,17,0,103.029111184873,'FINITE'),(40,17,1,-197945.99875179995,'FINITE'),(41,22,0,45.93634648032922,'FINITE'),(42,22,1,-1139801.0252695284,'FINITE'),(43,25,0,43.0239407766943,'FINITE'),(44,25,1,-1339655.9931073517,'FINITE'),(45,21,0,112.71281469838695,'FINITE'),(46,21,1,-123299.39443099839,'FINITE'),(47,24,0,113.25491800301415,'FINITE'),(48,24,1,-629137.6469654278,'FINITE'),(49,23,0,113.06471274449791,'FINITE'),(50,23,1,-567844.7964606853,'FINITE'),(51,27,0,111.9311091747674,'FINITE'),(52,27,1,-533822.1866991696,'FINITE'),(53,26,0,113.34743084794755,'FINITE'),(54,26,1,-550029.2597339879,'FINITE'),(55,28,0,113.31352622886077,'FINITE'),(56,28,1,-729058.4742935777,'FINITE'),(57,29,0,112.36925677769936,'FINITE'),(58,29,1,-670750.1474819395,'FINITE'),(59,30,0,112.62217824240277,'FINITE'),(60,30,1,3350.413979967195,'FINITE'),(61,31,0,112.74902400700937,'FINITE'),(62,31,1,-60640.64439693188,'FINITE'),(63,32,0,112.72896558045777,'FINITE'),(64,32,1,-624696.2735996608,'FINITE'),(65,34,0,112.21618937958924,'FINITE'),(66,34,1,-710108.352010747,'FINITE'),(67,33,0,112.11364319201695,'FINITE'),(68,33,1,-735751.6485498595,'FINITE'),(69,35,0,112.72989441054854,'FINITE'),(70,35,1,-651126.5844158421,'FINITE'),(71,36,0,112.71152689385637,'FINITE'),(72,36,1,-623315.2072092164,'FINITE'),(73,37,0,112.68938249188322,'FINITE'),(74,37,1,-633620.1339231564,'FINITE'),(75,38,0,112.59535490583782,'FINITE'),(76,38,1,-782299.6727567316,'FINITE'),(77,39,0,112.64967971673975,'FINITE'),(78,39,1,-775786.5855883623,'FINITE'),(79,40,0,112.72746032969731,'FINITE'),(80,40,1,-729767.1426018522,'FINITE');
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trials`
--

LOCK TABLES `trials` WRITE;
/*!40000 ALTER TABLE `trials` DISABLE KEYS */;
INSERT INTO `trials` VALUES (1,0,1,'COMPLETE','2023-04-07 21:21:04','2023-04-08 03:15:22'),(2,1,1,'COMPLETE','2023-04-07 21:21:05','2023-04-08 03:13:52'),(3,2,1,'COMPLETE','2023-04-07 21:21:05','2023-04-08 02:46:18'),(4,3,1,'COMPLETE','2023-04-07 21:21:05','2023-04-08 02:49:49'),(5,4,1,'COMPLETE','2023-04-07 21:21:06','2023-04-08 02:54:35'),(6,5,1,'COMPLETE','2023-04-07 21:21:06','2023-04-08 03:00:01'),(7,6,1,'COMPLETE','2023-04-07 21:21:07','2023-04-08 03:04:27'),(8,7,1,'COMPLETE','2023-04-07 21:21:08','2023-04-08 02:40:14'),(9,8,1,'COMPLETE','2023-04-07 21:21:08','2023-04-08 03:09:18'),(10,9,1,'COMPLETE','2023-04-07 21:21:09','2023-04-08 02:51:35'),(11,10,1,'COMPLETE','2023-04-08 02:40:14','2023-04-08 08:01:56'),(12,11,1,'COMPLETE','2023-04-08 02:46:18','2023-04-08 08:14:09'),(13,12,1,'COMPLETE','2023-04-08 02:49:50','2023-04-08 08:18:03'),(14,13,1,'COMPLETE','2023-04-08 02:51:35','2023-04-08 08:12:34'),(15,14,1,'COMPLETE','2023-04-08 02:54:35','2023-04-08 08:27:52'),(16,15,1,'COMPLETE','2023-04-08 03:00:01','2023-04-08 08:39:15'),(17,16,1,'COMPLETE','2023-04-08 03:04:27','2023-04-08 08:58:02'),(18,17,1,'COMPLETE','2023-04-08 03:09:18','2023-04-08 08:35:18'),(19,18,1,'COMPLETE','2023-04-08 03:13:52','2023-04-08 08:33:27'),(20,19,1,'COMPLETE','2023-04-08 03:15:22','2023-04-08 08:57:41'),(21,20,1,'COMPLETE','2023-04-08 08:01:56','2023-04-08 13:58:40'),(22,21,1,'COMPLETE','2023-04-08 08:12:34','2023-04-08 13:37:03'),(23,22,1,'COMPLETE','2023-04-08 08:14:09','2023-04-08 14:01:34'),(24,23,1,'COMPLETE','2023-04-08 08:18:03','2023-04-08 14:00:45'),(25,24,1,'COMPLETE','2023-04-08 08:27:52','2023-04-08 13:53:03'),(26,25,1,'COMPLETE','2023-04-08 08:33:27','2023-04-08 14:18:42'),(27,26,1,'COMPLETE','2023-04-08 08:35:18','2023-04-08 14:15:56'),(28,27,1,'COMPLETE','2023-04-08 08:39:15','2023-04-08 14:20:57'),(29,28,1,'COMPLETE','2023-04-08 08:57:41','2023-04-08 14:42:54'),(30,29,1,'COMPLETE','2023-04-08 08:58:02','2023-04-08 14:55:16'),(31,30,1,'COMPLETE','2023-04-08 13:37:03','2023-04-08 19:31:07'),(32,31,1,'COMPLETE','2023-04-08 13:53:03','2023-04-08 19:45:30'),(33,32,1,'COMPLETE','2023-04-08 13:58:40','2023-04-08 19:48:35'),(34,33,1,'COMPLETE','2023-04-08 14:00:45','2023-04-08 19:47:04'),(35,34,1,'COMPLETE','2023-04-08 14:01:34','2023-04-08 19:53:32'),(36,35,1,'COMPLETE','2023-04-08 14:15:56','2023-04-08 19:57:48'),(37,36,1,'COMPLETE','2023-04-08 14:18:42','2023-04-08 20:03:08'),(38,37,1,'COMPLETE','2023-04-08 14:20:57','2023-04-08 20:03:30'),(39,38,1,'COMPLETE','2023-04-08 14:42:54','2023-04-08 20:19:08'),(40,39,1,'COMPLETE','2023-04-08 14:55:16','2023-04-08 20:26:06');
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

-- Dump completed on 2023-04-08 20:46:32
