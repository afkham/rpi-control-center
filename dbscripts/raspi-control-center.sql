CREATE DATABASE  IF NOT EXISTS `RPI_CONTROL_CENTER` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `RPI_CONTROL_CENTER`;
-- MySQL dump 10.13  Distrib 5.6.13, for osx10.6 (i386)
--
-- Host: 127.0.0.1    Database: RPI_CONTROL_CENTER
-- ------------------------------------------------------
-- Server version	5.6.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `KV_PAIR`
--

DROP TABLE IF EXISTS `KV_PAIR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `KV_PAIR` (
  `k` varchar(100) NOT NULL,
  `v` varchar(200) NOT NULL,
  PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KV_PAIR`
--

LOCK TABLES `KV_PAIR` WRITE;
/*!40000 ALTER TABLE `KV_PAIR` DISABLE KEYS */;
/*!40000 ALTER TABLE `KV_PAIR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RASP_PI`
--

DROP TABLE IF EXISTS `RASP_PI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RASP_PI` (
  `mac` varchar(100) NOT NULL,
  `ip` varchar(100) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `label` varchar(45) DEFAULT NULL,
  `mode` varchar(45) DEFAULT NULL,
  `owner` varchar(100) DEFAULT NULL,
  `blink` bit(1) DEFAULT NULL,
  `reboot` bit(1) DEFAULT NULL,
  `selected` bit(1) DEFAULT NULL,
  `zoneID` varchar(100) DEFAULT NULL,
  `consumer_key` varchar(200) DEFAULT NULL,
  `consumer_secret` varchar(200) DEFAULT NULL,
  `user_checkin_url` varchar(200) DEFAULT NULL,
  `sw_update_reqd` bit(1) DEFAULT NULL,
  PRIMARY KEY (`mac`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RASP_PI`
--

LOCK TABLES `RASP_PI` WRITE;
/*!40000 ALTER TABLE `RASP_PI` DISABLE KEYS */;
/*!40000 ALTER TABLE `RASP_PI` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-06-09  9:32:33
