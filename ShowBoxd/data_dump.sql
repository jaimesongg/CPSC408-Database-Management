-- MySQL dump 10.13  Distrib 9.4.0, for macos15 (arm64)
--
-- Host: localhost    Database: Showboxd
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Table structure for table `Genre`
--

DROP TABLE IF EXISTS `Genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Genre` (
  `GenreID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`GenreID`),
  KEY `idx_genre_name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genre`
--

LOCK TABLES `Genre` WRITE;
/*!40000 ALTER TABLE `Genre` DISABLE KEYS */;
INSERT INTO `Genre` VALUES (1,'Action'),(2,'Adventure'),(3,'Animation'),(4,'Biography'),(5,'Comedy'),(6,'Crime'),(7,'Dark Comedy'),(8,'Drama'),(9,'Fantasy'),(10,'History'),(11,'Horror'),(12,'Medical'),(13,'Mockumentary'),(14,'Mystery'),(15,'Romance'),(16,'Sci-Fi'),(17,'Teen'),(18,'Thriller');
/*!40000 ALTER TABLE `Genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ratings`
--

DROP TABLE IF EXISTS `Ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ratings` (
  `RatingID` int NOT NULL AUTO_INCREMENT,
  `UserID` int DEFAULT NULL,
  `ShowID` int DEFAULT NULL,
  `RatingValue` decimal(2,1) DEFAULT NULL,
  PRIMARY KEY (`RatingID`),
  UNIQUE KEY `UC_User_Show` (`UserID`,`ShowID`),
  KEY `ShowID` (`ShowID`),
  CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`),
  CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`ShowID`) REFERENCES `Shows` (`ShowID`),
  CONSTRAINT `ratings_chk_1` CHECK ((`RatingValue` in (1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0)))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ratings`
--

LOCK TABLES `Ratings` WRITE;
/*!40000 ALTER TABLE `Ratings` DISABLE KEYS */;
INSERT INTO `Ratings` VALUES (1,1,8,2.5),(2,2,8,4.0),(3,2,1,1.5),(5,1,6,1.0),(6,1,2,5.0),(7,1,3,1.0),(8,1,4,5.0);
/*!40000 ALTER TABLE `Ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ShowGenre`
--

DROP TABLE IF EXISTS `ShowGenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ShowGenre` (
  `ShowID` int NOT NULL,
  `GenreID` int NOT NULL,
  PRIMARY KEY (`ShowID`,`GenreID`),
  KEY `GenreID` (`GenreID`),
  KEY `idx_sg` (`ShowID`,`GenreID`),
  CONSTRAINT `showgenre_ibfk_1` FOREIGN KEY (`ShowID`) REFERENCES `Shows` (`ShowID`),
  CONSTRAINT `showgenre_ibfk_2` FOREIGN KEY (`GenreID`) REFERENCES `Genre` (`GenreID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShowGenre`
--

LOCK TABLES `ShowGenre` WRITE;
/*!40000 ALTER TABLE `ShowGenre` DISABLE KEYS */;
INSERT INTO `ShowGenre` VALUES (3,1),(5,1),(7,1),(3,2),(5,2),(7,2),(5,3),(9,3),(8,4),(4,5),(9,5),(1,6),(9,7),(1,8),(2,8),(3,8),(6,8),(8,8),(9,8),(10,8),(3,9),(5,9),(7,9),(8,10),(2,11),(10,12),(4,13),(2,14),(6,15),(10,15),(2,16),(7,16),(6,17),(1,18);
/*!40000 ALTER TABLE `ShowGenre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Shows`
--

DROP TABLE IF EXISTS `Shows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Shows` (
  `ShowID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(100) NOT NULL,
  `ReleaseYear` year DEFAULT NULL,
  `Description` text,
  `EpCount` int DEFAULT NULL,
  `AverageRating` decimal(3,1) DEFAULT NULL,
  PRIMARY KEY (`ShowID`),
  KEY `idx_show_title` (`Title`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Shows`
--

LOCK TABLES `Shows` WRITE;
/*!40000 ALTER TABLE `Shows` DISABLE KEYS */;
INSERT INTO `Shows` VALUES (1,'Breaking Bad',2008,'A chemistry teacher turns to making meth after a cancer diagnosis.',62,1.5),(2,'Stranger Things',2016,'A group of kids uncover supernatural mysteries in their town.',34,NULL),(3,'Game of Thrones',2011,'Noble families battle for control of the Iron Throne.',73,1.0),(4,'The Office',2005,'A mockumentary about the daily lives of office workers.',201,5.0),(5,'Avatar: The Last Airbender',2005,'Aang must master the elements and bring peace to the world.',61,NULL),(6,'Euphoria',2019,'Teens navigate identity, trauma, addiction, and relationships.',18,1.0),(7,'The Mandalorian',2019,'A bounty hunter protects a mysterious child in the Star Wars universe.',24,NULL),(8,'The Crown',2016,'The life and reign of Queen Elizabeth II.',60,3.3),(9,'BoJack Horseman',2014,'A washed-up actor struggles with addiction and self-worth.',77,NULL),(10,'Grey\'s Anatomy',2005,'Surgeons navigate their careers, relationships, and personal lives.',430,NULL);
/*!40000 ALTER TABLE `Shows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `showwithgenres`
--

DROP TABLE IF EXISTS `showwithgenres`;
/*!50001 DROP VIEW IF EXISTS `showwithgenres`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `showwithgenres` AS SELECT 
 1 AS `ShowID`,
 1 AS `Title`,
 1 AS `Genres`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (3,''),(5,'berkeleyburbank'),(4,'jamiesong'),(2,'joeyshoda'),(1,'margoburbank');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Watchlist`
--

DROP TABLE IF EXISTS `Watchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Watchlist` (
  `WatchlistID` int NOT NULL AUTO_INCREMENT,
  `UserID` int DEFAULT NULL,
  PRIMARY KEY (`WatchlistID`),
  UNIQUE KEY `UserID` (`UserID`),
  CONSTRAINT `watchlist_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Watchlist`
--

LOCK TABLES `Watchlist` WRITE;
/*!40000 ALTER TABLE `Watchlist` DISABLE KEYS */;
INSERT INTO `Watchlist` VALUES (1,1),(2,2),(3,4),(4,5);
/*!40000 ALTER TABLE `Watchlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WatchlistShows`
--

DROP TABLE IF EXISTS `WatchlistShows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WatchlistShows` (
  `WatchlistID` int NOT NULL,
  `ShowID` int NOT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`WatchlistID`,`ShowID`),
  KEY `ShowID` (`ShowID`),
  CONSTRAINT `watchlistshows_ibfk_1` FOREIGN KEY (`WatchlistID`) REFERENCES `Watchlist` (`WatchlistID`),
  CONSTRAINT `watchlistshows_ibfk_2` FOREIGN KEY (`ShowID`) REFERENCES `Shows` (`ShowID`),
  CONSTRAINT `watchlistshows_chk_1` CHECK ((`Status` in (_utf8mb4'Watched',_utf8mb4'Like',_utf8mb4'Plan to Watch')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WatchlistShows`
--

LOCK TABLES `WatchlistShows` WRITE;
/*!40000 ALTER TABLE `WatchlistShows` DISABLE KEYS */;
INSERT INTO `WatchlistShows` VALUES (1,2,'Plan to Watch'),(1,6,'Like'),(1,8,'Plan to Watch'),(2,8,'Like'),(3,3,'Plan to Watch'),(3,5,'Plan to Watch'),(4,1,'Plan to Watch'),(4,6,'Plan to Watch');
/*!40000 ALTER TABLE `WatchlistShows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `showwithgenres`
--

/*!50001 DROP VIEW IF EXISTS `showwithgenres`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `showwithgenres` AS select `s`.`ShowID` AS `ShowID`,`s`.`Title` AS `Title`,group_concat(`g`.`Name` separator ', ') AS `Genres` from ((`shows` `s` join `showgenre` `sg` on((`s`.`ShowID` = `sg`.`ShowID`))) join `genre` `g` on((`sg`.`GenreID` = `g`.`GenreID`))) group by `s`.`ShowID`,`s`.`Title` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-12 17:31:09
