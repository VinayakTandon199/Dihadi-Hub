-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: agency_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agency`
--

DROP TABLE IF EXISTS `agency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `experience` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `address` text,
  `contact` varchar(20) DEFAULT NULL,
  `work_shift` enum('morning','evening','night','flexible') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `agency_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agency`
--

LOCK TABLES `agency` WRITE;
/*!40000 ALTER TABLE `agency` DISABLE KEYS */;
INSERT INTO `agency` VALUES (1,10,'QuickServe Agency','10 years','Cook','Dehradun, Uttarakhand','9876543210','morning','2026-04-07 07:08:28'),(61,10,'QuickServe Agency','4 years','Cook','Delhi','9984862464','morning','2026-04-07 17:34:53'),(62,1,'TasteMasters Services','11 years','Cook','Mumbai','9362758934','evening','2026-04-07 17:34:53'),(63,3,'HomeChef Solutions','10 years','Cook','Bangalore','9829429632','evening','2026-04-07 17:34:53'),(64,7,'KitchenPro Agency','6 years','Cook','Lucknow','9959880801','evening','2026-04-07 17:34:53'),(65,9,'FoodEase Services','10 years','Cook','Jaipur','9595865494','morning','2026-04-07 17:34:53'),(68,10,'SecureShield Agency','9 years','Security Guard','Pune','9654195970','evening','2026-04-07 17:35:29'),(69,1,'IronWall Security','14 years','Security Guard','Hyderabad','9109352419','morning','2026-04-07 17:35:29'),(70,3,'GuardianForce Services','5 years','Security Guard','Chandigarh','9284903796','evening','2026-04-07 17:35:29'),(71,7,'SafeNet Protection','11 years','Security Guard','Indore','9239789853','evening','2026-04-07 17:35:29'),(72,9,'AlphaSecure Agency','12 years','Security Guard','Ahmedabad','9890787188','morning','2026-04-07 17:35:29'),(75,10,'HomeCare Agency','3 years','House Help','Kolkata','9869398229','morning','2026-04-07 17:36:51'),(76,1,'CleanAssist Services','5 years','House Help','Chennai','9250610757','morning','2026-04-07 17:36:51'),(77,3,'UrbanMaid Solutions','2 years','House Help','Bhopal','9375109796','morning','2026-04-07 17:36:51'),(78,7,'CarePlus Agency','6 years','House Help','Patna','9942294747','night','2026-04-07 17:36:51'),(79,9,'DailyHelp Services','7 years','House Help','Surat','9655616709','night','2026-04-07 17:36:51'),(82,10,'DrivePro Agency','3 years','Driver','Nagpur','9900919066','morning','2026-04-07 17:38:10'),(83,1,'RapidRide Services','10 years','Driver','Kanpur','9577216584','evening','2026-04-07 17:38:10'),(84,3,'CityDrive Solutions','11 years','Driver','Vadodara','9452513366','night','2026-04-07 17:38:10'),(85,7,'AutoAssist Agency','9 years','Driver','Coimbatore','9116222953','evening','2026-04-07 17:38:10'),(86,9,'SafeDrive Services','12 years','Driver','Visakhapatnam','9879976874','night','2026-04-07 17:38:10'),(89,10,'GreenLeaf Agency','10 years','Gardener','Mysore','9669095287','evening','2026-04-07 17:38:59'),(90,1,'NatureCare Services','6 years','Gardener','Nashik','9146355581','night','2026-04-07 17:38:59'),(91,3,'GardenPro Solutions','8 years','Gardener','Raipur','9142875200','morning','2026-04-07 17:38:59'),(92,7,'EcoGrow Agency','2 years','Gardener','Ranchi','9478416801','morning','2026-04-07 17:38:59'),(93,9,'PlantCare Services','10 years','Gardener','Guwahati','9415715121','morning','2026-04-07 17:38:59'),(96,10,'PowerFix Agency','9 years','Electrician','Noida','9904648323','night','2026-04-07 17:40:00'),(97,1,'VoltCare Services','7 years','Electrician','Gurgaon','9419936213','night','2026-04-07 17:40:00'),(98,3,'SparkPro Solutions','8 years','Electrician','Pune','9369393773','morning','2026-04-07 17:40:00'),(99,7,'ElectroAssist Agency','6 years','Electrician','Thane','9413225522','night','2026-04-07 17:40:00'),(100,9,'CurrentCare Services','6 years','Electrician','Amritsar','9784411369','night','2026-04-07 17:40:00'),(103,10,'PipeCare Agency','3 years','Plumber','Varanasi','9344710074','morning','2026-04-07 17:40:53'),(104,1,'FlowFix Services','4 years','Plumber','Agra','9237290936','morning','2026-04-07 17:40:53'),(105,3,'AquaPro Solutions','5 years','Plumber','Jodhpur','9876104326','night','2026-04-07 17:40:53'),(106,7,'DrainAssist Agency','8 years','Plumber','Madurai','9881492270','night','2026-04-07 17:40:53'),(107,9,'HydroCare Services','5 years','Plumber','Dehradun','9264566288','morning','2026-04-07 17:40:53'),(110,10,'ShieldForce Agency','6 years','Gunman','Jaipur','9565856263','morning','2026-04-07 17:41:45'),(111,1,'IronGuard Services','10 years','Gunman','Bhopal','9708844038','night','2026-04-07 17:41:45'),(112,3,'DefencePro Solutions','11 years','Gunman','Lucknow','9229405402','night','2026-04-07 17:41:45'),(113,7,'SecureArms Agency','5 years','Gunman','Surat','9313644620','night','2026-04-07 17:41:45'),(114,9,'EliteGuard Services','7 years','Gunman','Patiala','9197625181','night','2026-04-07 17:41:45'),(117,10,'CleanSweep Agency','5 years','Sweeper','Indore','9617906262','night','2026-04-07 17:42:44'),(118,1,'FreshSpace Services','2 years','Sweeper','Nagpur','9321027476','evening','2026-04-07 17:42:44'),(119,3,'HygienePro Solutions','6 years','Sweeper','Chandigarh','9198730502','evening','2026-04-07 17:42:44'),(120,7,'DustFree Agency','5 years','Sweeper','Coimbatore','9230699798','night','2026-04-07 17:42:44'),(121,9,'PureClean Services','2 years','Sweeper','Trivandrum','9690261723','night','2026-04-07 17:42:44'),(124,10,'WoodCraft Agency','7 years','Carpenter','Udaipur','9636246143','evening','2026-04-07 17:43:56'),(125,1,'TimberPro Services','6 years','Carpenter','Ludhiana','9883702135','morning','2026-04-07 17:43:56'),(126,3,'CraftBuild Solutions','7 years','Carpenter','Rajkot','9617526396','morning','2026-04-07 17:43:56'),(127,7,'FixWood Agency','8 years','Carpenter','Salem','9542155541','evening','2026-04-07 17:43:56'),(128,9,'PrimeCarpentry Services','10 years','Carpenter','Jabalpur','9799232042','evening','2026-04-07 17:43:56'),(131,10,'ColorCraft Agency','8 years','Painter','Amritsar','9386428119','night','2026-04-07 17:44:50'),(132,1,'PaintPro Services','5 years','Painter','Gwalior','9965503968','evening','2026-04-07 17:44:50'),(133,3,'BrushMaster Solutions','4 years','Painter','Vijayawada','9406759662','night','2026-04-07 17:44:50'),(134,7,'PrimeCoat Agency','10 years','Painter','Aurangabad','9372167332','night','2026-04-07 17:44:50'),(135,9,'FineFinish Services','11 years','Painter','Meerut','9990877119','night','2026-04-07 17:44:50'),(138,10,'BuildMaster Agency','15 years','House Labour','Hyderabad','9300442087','night','2026-04-07 17:45:44'),(139,1,'SolidConstruct Services','5 years','House Labour','Pune','9514156281','morning','2026-04-07 17:45:44'),(140,3,'UrbanBuild Solutions','8 years','House Labour','Ahmedabad','9820567616','morning','2026-04-07 17:45:44'),(141,7,'PrimeStructure Agency','6 years','House Labour','Kochi','9663191132','night','2026-04-07 17:45:44'),(142,9,'DreamHome Builders','7 years','House Labour','Jaipur','9499966427','night','2026-04-07 17:45:44'),(145,1,'Test Agency','5 years','Cook','Mumbai','8888888888','morning','2026-04-08 01:17:15');
/*!40000 ALTER TABLE `agency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contract_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `date` date NOT NULL,
  `status` enum('present','absent') NOT NULL,
  `month` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_attendance` (`contract_id`,`staff_id`,`date`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES (1,1,8,'2026-04-07','present',4,2026),(3,1,8,'2026-04-03','present',4,2026),(4,1,8,'2026-04-04','present',4,2026),(5,1,8,'2026-04-01','absent',4,2026),(6,1,8,'2026-04-05','present',4,2026),(7,1,9,'2026-04-02','present',4,2026),(8,1,9,'2026-04-03','present',4,2026),(9,1,9,'2026-04-04','present',4,2026),(10,1,9,'2026-04-05','present',4,2026),(13,1,9,'2026-04-06','present',4,2026),(14,1,9,'2026-04-07','absent',4,2026),(15,1,8,'2026-04-02','present',4,2026),(19,1,8,'2026-04-06','present',4,2026),(28,1,9,'2026-04-01','absent',4,2026),(40,1,8,'2026-04-08','present',4,2026),(47,1,8,'2026-04-09','present',4,2026);
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `experience` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `address` text,
  `contact` varchar(20) DEFAULT NULL,
  `work_shift` enum('morning','evening','night','flexible') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `client_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
INSERT INTO `client` VALUES (1,7,'Vinayak Tandon',20,'other',NULL,NULL,'begampul','1234567891',NULL,'2026-04-01 07:14:33'),(2,7,'Test Client',25,'male','2 years','Cook','Delhi','9999999999','morning','2026-04-08 01:17:15');
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_requests`
--

DROP TABLE IF EXISTS `contract_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `agency_id` int NOT NULL,
  `staff_type` varchar(100) NOT NULL,
  `staff_count` int DEFAULT '1',
  `min_age` int DEFAULT NULL,
  `max_salary` int DEFAULT NULL,
  `work_shift` varchar(50) DEFAULT NULL,
  `address` text,
  `is_permanent` tinyint(1) DEFAULT '0',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_cr_client` (`client_id`),
  KEY `fk_cr_agency` (`agency_id`),
  CONSTRAINT `fk_cr_agency` FOREIGN KEY (`agency_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cr_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_requests`
--

LOCK TABLES `contract_requests` WRITE;
/*!40000 ALTER TABLE `contract_requests` DISABLE KEYS */;
INSERT INTO `contract_requests` VALUES (1,7,10,'Cook',2,25,350,'day','Test Address',1,'2025-06-01',NULL,'rejected','2026-04-07 16:49:37'),(4,7,3,'Plumber',1,22,446,'night','delhi',1,'2026-04-15',NULL,'pending','2026-04-07 17:55:39'),(5,7,7,'House Labour',15,22,700,'day','meri gali me',0,'2026-04-08','2026-08-13','pending','2026-04-08 02:16:20'),(6,7,10,'Cook',2,28,500,'day','meerut',1,'2026-04-16',NULL,'rejected','2026-04-14 18:37:56'),(7,7,10,'Cook',1,40,667,'day','ghar pe',1,'2026-04-16',NULL,'rejected','2026-04-14 18:54:30'),(8,7,10,'Cook',3,2,3,'day','r2efdsvfsvdfsvdfvefvfe',1,'2026-04-15',NULL,'pending','2026-04-14 18:56:12'),(9,7,10,'Cook',2,40,500,'Morning','sdsaa',1,'2026-04-15',NULL,'accepted','2026-04-14 19:15:05');
/*!40000 ALTER TABLE `contract_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_staff`
--

DROP TABLE IF EXISTS `contract_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contract_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `working_hours` varchar(50) DEFAULT NULL,
  `per_day_salary` decimal(10,2) NOT NULL DEFAULT '0.00',
  `salary` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contract_id` (`contract_id`),
  KEY `fk_contract_staff_actual` (`staff_id`),
  CONSTRAINT `contract_staff_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_contract_staff_actual` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_staff`
--

LOCK TABLES `contract_staff` WRITE;
/*!40000 ALTER TABLE `contract_staff` DISABLE KEYS */;
INSERT INTO `contract_staff` VALUES (1,1,9,'8 hours',300.00,NULL),(2,1,8,'8 hours',350.00,NULL),(3,1,9,'8 hours',300.00,NULL),(4,1,8,'8 hours',350.00,NULL),(5,1,9,'8 hours',300.00,NULL),(6,1,8,'8 hours',350.00,NULL),(13,9,69,NULL,0.00,320.00),(14,9,4,NULL,0.00,450.00);
/*!40000 ALTER TABLE `contract_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contracts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `agency_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_permanent` tinyint(1) DEFAULT '0',
  `status` enum('active','dismissed','pending') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `requested_type` varchar(100) DEFAULT NULL,
  `work_shift` varchar(50) DEFAULT NULL,
  `staff_count` int DEFAULT '1',
  `affordable_salary` decimal(10,2) DEFAULT NULL,
  `staff_age_pref` int DEFAULT NULL,
  `work_address` text,
  `staff_type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `agency_id` (`agency_id`),
  CONSTRAINT `contracts_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contracts_ibfk_2` FOREIGN KEY (`agency_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
INSERT INTO `contracts` VALUES (1,7,10,'2025-04-01',NULL,1,'active','2026-04-07 07:09:51',NULL,NULL,1,NULL,NULL,NULL,NULL),(9,7,10,'2026-04-15',NULL,1,'active','2026-04-14 20:05:12',NULL,NULL,2,NULL,NULL,NULL,'Cook');
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dismiss_requests`
--

DROP TABLE IF EXISTS `dismiss_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dismiss_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contract_id` int NOT NULL,
  `requested_by` int NOT NULL,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `contract_id` (`contract_id`),
  KEY `requested_by` (`requested_by`),
  CONSTRAINT `dismiss_requests_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `dismiss_requests_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dismiss_requests`
--

LOCK TABLES `dismiss_requests` WRITE;
/*!40000 ALTER TABLE `dismiss_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `dismiss_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketplace_items`
--

DROP TABLE IF EXISTS `marketplace_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marketplace_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` enum('Cook','Security Guard','House Help','Driver','Gardener','Electrician','Plumber','Gunman','Sweeper','Carpenter','Painter','House Labour') NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT '/images/default-item.png',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketplace_items`
--

LOCK TABLES `marketplace_items` WRITE;
/*!40000 ALTER TABLE `marketplace_items` DISABLE KEYS */;
INSERT INTO `marketplace_items` VALUES (1,'Premium Non-Stick Pan','Cook',1200.00,'Heavy duty pan for professional cooking','/images/default-item.png'),(2,'Chef Knife Set','Cook',2500.00,'Stainless steel 5-piece set','/images/default-item.png'),(3,'Apron & Glove Set','Cook',450.00,'Heat resistant cotton set','/images/default-item.png'),(4,'Induction Cooktop','Cook',3500.00,'Fast heating, energy efficient','/images/default-item.png'),(5,'Potato (Aloo) - 5kg','Cook',150.00,'Fresh farm potatoes','/images/default-item.png'),(6,'Onion (Pyaz) - 5kg','Cook',250.00,'Red onions, export quality','/images/default-item.png'),(7,'Tomato (Tamatar) - 2kg','Cook',80.00,'Ripe red tomatoes','/images/default-item.png'),(8,'Ginger-Garlic Paste (500g)','Cook',120.00,'Pure homemade style paste','/images/default-item.png'),(9,'Green Chillies - 500g','Cook',60.00,'Spicy organic chillies','/images/default-item.png'),(10,'Spice Box (Full Masala)','Cook',800.00,'Set of 7 essential spices','/images/default-item.png'),(11,'LED High-Beam Torch','Security Guard',900.00,'Rechargeable long-range torch','/images/default-item.png'),(12,'Steel Defense Baton','Security Guard',600.00,'Heavy duty retractable baton','/images/default-item.png'),(13,'Standard Uniform Set','Security Guard',1800.00,'Shirt, pants and tie','/images/default-item.png'),(14,'Heavy Duty Security Boots','Security Guard',2200.00,'Steel-toe safety boots','/images/default-item.png'),(15,'Walkie-Talkie Set','Security Guard',4500.00,'Long range communication device','/images/default-item.png'),(16,'Handheld Metal Detector','Security Guard',3200.00,'Portable scanning device','/images/default-item.png'),(17,'Security Cap with Badge','Security Guard',250.00,'Official guard cap','/images/default-item.png'),(18,'Duty Belt with Pouches','Security Guard',550.00,'Adjustable belt for equipment','/images/default-item.png'),(19,'Stainless Steel Whistle','Security Guard',100.00,'High-pitch signal whistle','/images/default-item.png'),(20,'Daily Log Register','Security Guard',150.00,'200 pages entry book','/images/default-item.png'),(21,'Dishwashing Gel 5L','House Help',650.00,'Lemon fresh grease cutter','/images/default-item.png'),(22,'Microfiber Cleaning Mop','House Help',1100.00,'360 degree spin mop','/images/default-item.png'),(23,'Toilet Cleaner (Pack of 3)','House Help',400.00,'Strong disinfectant','/images/default-item.png'),(24,'Glass & Surface Spray','House Help',200.00,'Streak-free cleaning','/images/default-item.png'),(25,'Laundry Detergent 5kg','House Help',850.00,'Front/Top load specialist','/images/default-item.png'),(26,'Soft Dusting Broom','House Help',300.00,'Long handle floor broom','/images/default-item.png'),(27,'Microfiber Cloth Pack','House Help',450.00,'Pack of 10 lint-free cloths','/images/default-item.png'),(28,'Garbage Bags (Bulk)','House Help',350.00,'Biodegradable large bags','/images/default-item.png'),(29,'Scrubbing Brush Set','House Help',250.00,'Tile and grout cleaners','/images/default-item.png'),(30,'Floor Disinfectant (Phenyle)','House Help',500.00,'5L germ-kill solution','/images/default-item.png'),(31,'Premium Car Perfume','Driver',450.00,'Long lasting gel fragrance','/images/default-item.png'),(32,'Steering Wheel Cover','Driver',700.00,'Anti-slip leather grip','/images/default-item.png'),(33,'Microfiber Towel Large','Driver',300.00,'Super absorbent car towel','/images/default-item.png'),(34,'Dashboard Polish Spray','Driver',400.00,'High gloss protection','/images/default-item.png'),(35,'Magnetic Phone Mount','Driver',500.00,'Stable dashboard holder','/images/default-item.png'),(36,'Car Fast Charger','Driver',650.00,'Dual port USB-C charger','/images/default-item.png'),(37,'Tire Pressure Gauge','Driver',350.00,'Digital accurate reading','/images/default-item.png'),(38,'Emergency First Aid Kit','Driver',1200.00,'Compact medical supplies','/images/default-item.png'),(39,'Portable Car Vacuum','Driver',2500.00,'High suction handheld cleaner','/images/default-item.png'),(40,'Glass Cleaner Spray','Driver',250.00,'Anti-fog windshield spray','/images/default-item.png'),(41,'Digital Multimeter','Electrician',1500.00,'LCD AC/DC testing device','/images/default-item.png'),(42,'Insulated Screwdriver Set','Electrician',850.00,'VDE certified safety set','/images/default-item.png'),(43,'Copper Wire Roll (90m)','Electrician',2800.00,'1.5mm fire resistant wire','/images/default-item.png'),(44,'Electrical Tape Pack','Electrician',150.00,'Assorted color PVC tapes','/images/default-item.png'),(45,'Wire Stripper & Cutter','Electrician',450.00,'Professional crimping tool','/images/default-item.png'),(46,'Voltage Tester Pen','Electrician',120.00,'Non-contact safety tester','/images/default-item.png'),(47,'Soldering Iron Kit','Electrician',950.00,'60W with stand and wire','/images/default-item.png'),(48,'Heavy Duty Extension Board','Electrician',1100.00,'4-socket surge protector','/images/default-item.png'),(49,'LED Bulb 9W (Pack of 10)','Electrician',800.00,'Energy saving pack','/images/default-item.png'),(50,'Compact Drill Machine','Electrician',3500.00,'Impact drill for walls','/images/default-item.png'),(51,'Adjustable Pipe Wrench','Plumber',900.00,'14-inch heavy duty wrench','/images/default-item.png'),(52,'Teflon Tape (Box of 10)','Plumber',300.00,'Leak-proof sealing tape','/images/default-item.png'),(53,'Industrial Sink Plunger','Plumber',450.00,'High suction block remover','/images/default-item.png'),(54,'PVC Solvent Cement','Plumber',250.00,'Quick-dry bonding liquid','/images/default-item.png'),(55,'Steel Hacksaw Frame','Plumber',550.00,'For metal and PVC cutting','/images/default-item.png'),(56,'Tap Washers Assorted','Plumber',200.00,'Rubber washers for leaks','/images/default-item.png'),(57,'Thread Sealant Paste','Plumber',180.00,'Professional grade sealant','/images/default-item.png'),(58,'Basin Nut Wrench','Plumber',750.00,'For tight space plumbing','/images/default-item.png'),(59,'Pipe Cutter Tool','Plumber',1200.00,'Clean cut for copper/PVC','/images/default-item.png'),(60,'Flexible Drain Snake','Plumber',800.00,'Clog remover for pipes','/images/default-item.png'),(61,'Professional Pruning Shears','Gardener',850.00,'Sharp bypass branch cutter','/images/default-item.png'),(62,'Metal Watering Can','Gardener',1100.00,'10L rust-proof can','/images/default-item.png'),(63,'Garden Trowel & Fork','Gardener',500.00,'Soil digging hand tools','/images/default-item.png'),(64,'Organic Fertilizer (10kg)','Gardener',750.00,'Natural plant nutrient','/images/default-item.png'),(65,'Designer Flower Pot Set','Gardener',1500.00,'Set of 5 ceramic pots','/images/default-item.png'),(66,'Rubber Garden Hose (30m)','Gardener',1200.00,'Durable watering pipe','/images/default-item.png'),(67,'Protective Garden Gloves','Gardener',300.00,'Thorn-proof rubber grip','/images/default-item.png'),(68,'Manual Grass Cutter','Gardener',2800.00,'Hand-push lawn mower','/images/default-item.png'),(69,'Plant Spray Bottle','Gardener',250.00,'Mist spray for leaves','/images/default-item.png'),(70,'Seed Variety Pack','Gardener',400.00,'20 types of flower seeds','/images/default-item.png'),(71,'Tactical Gun Holster','Gunman',1200.00,'Quick-draw waist holster','/images/default-item.png'),(72,'Weapon Cleaning Kit','Gunman',1800.00,'Universal brush and oil set','/images/default-item.png'),(73,'Bulletproof Tactical Vest','Gunman',8500.00,'Level 3A protection vest','/images/default-item.png'),(74,'Noise Cancelling Earmuffs','Gunman',2200.00,'Safety gear for shooting','/images/default-item.png'),(75,'Tactical Flashlight','Gunman',1500.00,'Strobe mode high intensity','/images/default-item.png'),(76,'Gun Safe Box','Gunman',5500.00,'Biometric lock security box','/images/default-item.png'),(77,'Range Gear Bag','Gunman',2500.00,'Heavy duty equipment bag','/images/default-item.png'),(78,'Protective Shooting Glasses','Gunman',900.00,'Anti-scratch safety lens','/images/default-item.png'),(79,'Leather Duty Boots','Gunman',3500.00,'Military style tactical boots','/images/default-item.png'),(80,'Flashlight Belt Mount','Gunman',300.00,'360 degree rotating clip','/images/default-item.png'),(81,'Long Handle Road Broom','Sweeper',400.00,'Wide outdoor cleaning broom','/images/default-item.png'),(82,'Industrial Dustpan Set','Sweeper',600.00,'Large metal pan with handle','/images/default-item.png'),(83,'Disinfectant Fluid 5L','Sweeper',550.00,'Pine scented floor cleaner','/images/default-item.png'),(84,'Bleaching Powder 5kg','Sweeper',450.00,'Sanitization powder','/images/default-item.png'),(85,'Heavy Duty Rubber Gloves','Sweeper',200.00,'Protective cleaning gloves','/images/default-item.png'),(86,'Face Mask N95 (Pack)','Sweeper',500.00,'Dust protection for workers','/images/default-item.png'),(87,'Large Wheelie Bin','Sweeper',3500.00,'120L mobile garbage bin','/images/default-item.png'),(88,'Glass Cleaning Squeegee','Sweeper',350.00,'Rubber blade window cleaner','/images/default-item.png'),(89,'Scrubbing Floor Brush','Sweeper',450.00,'Tough bristle deck brush','/images/default-item.png'),(90,'Janitorial Cleaning Cart','Sweeper',6500.00,'Mobile station for supplies','/images/default-item.png'),(91,'Claw Hammer 16oz','Carpenter',650.00,'Steel head with grip','/images/default-item.png'),(92,'Measuring Tape (5m)','Carpenter',250.00,'Digital lock tape measure','/images/default-item.png'),(93,'Strong Wood Glue 1kg','Carpenter',400.00,'PVA high strength bond','/images/default-item.png'),(94,'Hand Saw 18-inch','Carpenter',750.00,'Fine-tooth wood cutter','/images/default-item.png'),(95,'Chisel Set (4 Piece)','Carpenter',1200.00,'Beveled edge steel chisels','/images/default-item.png'),(96,'Sandpaper Assorted Pack','Carpenter',300.00,'Grits from 80 to 220','/images/default-item.png'),(97,'Box of Wood Screws','Carpenter',450.00,'500 pieces mixed sizes','/images/default-item.png'),(98,'Spirit Level Tool','Carpenter',550.00,'Bubble level for accuracy','/images/default-item.png'),(99,'Wood Polish / Varnish','Carpenter',600.00,'Clear gloss protection','/images/default-item.png'),(100,'Corner Clamp Set','Carpenter',900.00,'90-degree angle clamps','/images/default-item.png'),(101,'Professional Brush Set','Painter',800.00,'5 brushes of mixed sizes','/images/default-item.png'),(102,'Paint Roller with Tray','Painter',600.00,'9-inch microfiber roller','/images/default-item.png'),(103,'Masking Tape (Pack of 5)','Painter',350.00,'Surface protection tape','/images/default-item.png'),(104,'Steel Putty Knife','Painter',250.00,'Wall repair scraping tool','/images/default-item.png'),(105,'White Wall Primer 10L','Painter',2200.00,'Interior/Exterior base coat','/images/default-item.png'),(106,'Paint Thinner 1L','Painter',300.00,'High grade solvent','/images/default-item.png'),(107,'Drop Cloth / Plastic Sheet','Painter',450.00,'Furniture protection cover','/images/default-item.png'),(108,'Sanding Block','Painter',150.00,'Ergonomic wall sander','/images/default-item.png'),(109,'Aluminium Step Ladder','Painter',4500.00,'6-foot foldable ladder','/images/default-item.png'),(110,'Color Mixing Palette','Painter',200.00,'Large tray for custom tints','/images/default-item.png'),(111,'Cement Bag (50kg)','House Labour',450.00,'Premium Grade-A cement','/images/default-item.png'),(112,'Construction Sand (Sack)','House Labour',120.00,'Coarse filtered river sand','/images/default-item.png'),(113,'Standard Red Bricks (100)','House Labour',1000.00,'Kiln-fired durable bricks','/images/default-item.png'),(114,'Steel Trowel (Karni)','House Labour',350.00,'Masonry bricklaying tool','/images/default-item.png'),(115,'Iron Mixing Pan (Tasla)','House Labour',400.00,'Heavy duty cement mixer pan','/images/default-item.png'),(116,'Plumb Bob (Sahul)','House Labour',250.00,'Vertical alignment tool','/images/default-item.png'),(117,'Construction Safety Helmet','House Labour',500.00,'ISI marked protective gear','/images/default-item.png'),(118,'Spirit Level 24-inch','House Labour',800.00,'Long level for wall check','/images/default-item.png'),(119,'Heavy Duty Pickaxe','House Labour',1200.00,'For soil and stone breaking','/images/default-item.png'),(120,'Masonry Thread (90m)','House Labour',100.00,'High tension marking line','/images/default-item.png');
/*!40000 ALTER TABLE `marketplace_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketplace_orders`
--

DROP TABLE IF EXISTS `marketplace_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marketplace_orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `store_type` varchar(50) NOT NULL,
  `delivery_time` varchar(100) NOT NULL,
  `status` enum('Pending','Delivered') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `marketplace_orders_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketplace_orders`
--

LOCK TABLES `marketplace_orders` WRITE;
/*!40000 ALTER TABLE `marketplace_orders` DISABLE KEYS */;
INSERT INTO `marketplace_orders` VALUES (3,7,200.00,'General','25 minutes','Pending','2026-04-08 07:04:54'),(4,7,1000.00,'General','35 minutes','Pending','2026-04-08 07:08:53');
/*!40000 ALTER TABLE `marketplace_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,10,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-07 16:49:37'),(2,1,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-07 17:53:43'),(3,1,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-07 17:53:47'),(4,3,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-07 17:55:39'),(5,7,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-08 02:16:20'),(6,7,'Your contract request was rejected by the agency.',0,'2026-04-14 18:27:04'),(7,7,'Your contract request was rejected by the agency.',0,'2026-04-14 18:27:12'),(8,10,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-14 18:37:56'),(9,10,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-14 18:54:30'),(10,10,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-14 18:56:12'),(11,10,'New contract request received from a client. Please review and deploy staff.',0,'2026-04-14 19:15:05'),(12,7,'Your contract request for Cook has been accepted!',1,'2026-04-14 20:05:12');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price_at_purchase` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `marketplace_orders` (`id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `marketplace_items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,3,120,2,100.00),(2,4,113,1,1000.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `experience` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `address` text,
  `contact` varchar(20) DEFAULT NULL,
  `work_shift` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expected_salary` decimal(10,2) DEFAULT NULL,
  `agency_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,8,'Priya Sharma',28,'female','4 years','Cook','Haridwar, Uttarakhand','9823456789','morning','2026-04-14 18:07:59',350.00,1),(2,9,'Rahul Kumar',25,'male','3 years','Cook','Dehradun, Uttarakhand','9812345678','morning','2026-04-14 18:07:59',300.00,1),(3,101,'Ramesh Kumar',34,'male','10 years','Cook','Delhi','9876543211','morning','2026-04-14 18:10:14',500.00,1),(4,102,'Sita Devi',29,'female','5 years','Cook','Meerut','9876543212','morning','2026-04-14 18:10:14',450.00,10),(5,103,'Anita Singh',31,'female','7 years','Cook','Noida','9876543213','morning','2026-04-14 18:10:14',480.00,1),(6,104,'Vikram Rathore',40,'male','15 years','Cook','Delhi','9876543214','morning','2026-04-14 18:10:14',600.00,10),(7,105,'Pooja Sharma',25,'female','3 years','Cook','Gurgaon','9876543215','morning','2026-04-14 18:10:14',400.00,1),(8,106,'Sher Singh',45,'male','20 years','Security Guard','Delhi','9876543216','night','2026-04-14 18:10:14',700.00,1),(9,107,'Dharam Pal',38,'male','12 years','Security Guard','Meerut','9876543217','night','2026-04-14 18:10:14',650.00,10),(10,108,'Rohan Mehra',32,'male','8 years','Security Guard','Noida','9876543218','night','2026-04-14 18:10:14',600.00,1),(11,109,'Karan Singh',35,'male','10 years','Security Guard','Delhi','9876543219','night','2026-04-14 18:10:14',620.00,10),(12,110,'Baljeet Singh',42,'male','18 years','Security Guard','Gurgaon','9876543220','night','2026-04-14 18:10:14',680.00,1),(13,111,'Mina Kumari',28,'female','4 years','House Help','Delhi','9876543221','morning','2026-04-14 18:10:14',350.00,1),(14,112,'Sarla Ben',35,'female','10 years','House Help','Meerut','9876543222','morning','2026-04-14 18:10:14',400.00,10),(15,113,'Geeta Rani',30,'female','6 years','House Help','Noida','9876543223','morning','2026-04-14 18:10:14',380.00,1),(16,114,'Lata Ji',40,'female','15 years','House Help','Delhi','9876543224','morning','2026-04-14 18:10:14',450.00,10),(17,115,'Kiran Bala',24,'female','2 years','House Help','Gurgaon','9876543225','morning','2026-04-14 18:10:14',300.00,1),(18,116,'Rajesh Pilot',33,'male','9 years','Driver','Delhi','9876543226','morning','2026-04-14 18:10:14',800.00,1),(19,117,'Sunil Chauffeur',42,'male','20 years','Driver','Meerut','9876543227','morning','2026-04-14 18:10:14',900.00,10),(20,118,'Amit Transport',29,'male','5 years','Driver','Noida','9876543228','morning','2026-04-14 18:10:14',750.00,1),(21,119,'Deepak Drive',36,'male','12 years','Driver','Delhi','9876543229','morning','2026-04-14 18:10:14',850.00,10),(22,120,'Suresh Gadi',31,'male','7 years','Driver','Gurgaon','9876543230','morning','2026-04-14 18:10:14',780.00,1),(23,121,'Mali Ram',50,'male','30 years','Gardener','Delhi','9876543231','morning','2026-04-14 18:10:14',450.00,1),(24,122,'Phool Chand',38,'male','15 years','Gardener','Meerut','9876543232','morning','2026-04-14 18:10:14',400.00,10),(25,123,'Hira Mali',30,'male','6 years','Gardener','Noida','9876543233','morning','2026-04-14 18:10:14',350.00,1),(26,124,'Bagicha Singh',45,'male','25 years','Gardener','Delhi','9876543234','morning','2026-04-14 18:10:14',500.00,10),(27,125,'Shyam Sunder',28,'male','4 years','Gardener','Gurgaon','9876543235','morning','2026-04-14 18:10:14',320.00,1),(28,126,'Bijli Billu',27,'male','5 years','Electrician','Delhi','9876543236','morning','2026-04-14 18:10:14',550.00,1),(29,127,'Short Circuit',35,'male','12 years','Electrician','Meerut','9876543237','morning','2026-04-14 18:10:14',600.00,10),(30,128,'Current Kumar',31,'male','8 years','Electrician','Noida','9876543238','morning','2026-04-14 18:10:14',580.00,1),(31,129,'Volt Verma',40,'male','18 years','Electrician','Delhi','9876543239','morning','2026-04-14 18:10:14',650.00,10),(32,130,'Wire Watson',29,'male','6 years','Electrician','Gurgaon','9876543240','morning','2026-04-14 18:10:14',560.00,1),(33,131,'Tapu Plumber',32,'male','10 years','Plumber','Delhi','9876543241','morning','2026-04-14 18:10:14',500.00,1),(34,132,'Nal Neeraj',28,'male','5 years','Plumber','Meerut','9876543242','morning','2026-04-14 18:10:14',450.00,10),(35,133,'Pipe Pradeep',36,'male','14 years','Plumber','Noida','9876543243','morning','2026-04-14 18:10:14',550.00,1),(36,134,'Sink Sonu',25,'male','3 years','Plumber','Delhi','9876543244','morning','2026-04-14 18:10:14',400.00,10),(37,135,'Leak Lokesh',42,'male','20 years','Plumber','Gurgaon','9876543245','morning','2026-04-14 18:10:14',600.00,1),(38,136,'Bullet Raja',38,'male','15 years','Gunman','Delhi','9876543246','day','2026-04-14 18:10:14',1000.00,1),(39,137,'Rifle Rahul',45,'male','22 years','Gunman','Meerut','9876543247','day','2026-04-14 18:10:14',1100.00,10),(40,138,'Pistol Prem',35,'male','12 years','Gunman','Noida','9876543248','day','2026-04-14 18:10:14',950.00,1),(41,139,'Trigger Tom',33,'male','10 years','Gunman','Delhi','9876543249','day','2026-04-14 18:10:14',980.00,10),(42,140,'Guard Golu',40,'male','18 years','Gunman','Gurgaon','9876543250','day','2026-04-14 18:10:14',1050.00,1),(43,141,'Safai Seth',30,'male','8 years','Sweeper','Delhi','9876543251','morning','2026-04-14 18:10:14',300.00,1),(44,142,'Jhadu Ji',26,'female','4 years','Sweeper','Meerut','9876543252','morning','2026-04-14 18:10:14',280.00,10),(45,143,'Kachra Khan',34,'male','10 years','Sweeper','Noida','9876543253','morning','2026-04-14 18:10:14',320.00,1),(46,144,'Broom Balram',40,'male','15 years','Sweeper','Delhi','9876543254','morning','2026-04-14 18:10:14',350.00,10),(47,145,'Dustbin Deepu',28,'male','6 years','Sweeper','Gurgaon','9876543255','morning','2026-04-14 18:10:14',290.00,1),(48,146,'Lakdi Lal',35,'male','12 years','Carpenter','Delhi','9876543256','morning','2026-04-14 18:10:14',600.00,1),(49,147,'Mistry Manoj',42,'male','20 years','Carpenter','Meerut','9876543257','morning','2026-04-14 18:10:14',700.00,10),(50,148,'Saw Sunil',29,'male','6 years','Carpenter','Noida','9876543258','morning','2026-04-14 18:10:14',550.00,1),(51,149,'Hammer Hari',33,'male','10 years','Carpenter','Delhi','9876543259','morning','2026-04-14 18:10:14',620.00,10),(52,150,'Nail Naresh',31,'male','8 years','Carpenter','Gurgaon','9876543260','morning','2026-04-14 18:10:14',580.00,1),(53,151,'Rangila Ram',28,'male','5 years','Painter','Delhi','9876543261','morning','2026-04-14 18:10:14',500.00,1),(54,152,'Brush Bobby',36,'male','14 years','Painter','Meerut','9876543262','morning','2026-04-14 18:10:14',550.00,10),(55,153,'Color Chintu',30,'male','7 years','Painter','Noida','9876543263','morning','2026-04-14 18:10:14',480.00,1),(56,154,'Wall Vicky',40,'male','18 years','Painter','Delhi','9876543264','morning','2026-04-14 18:10:14',600.00,10),(57,155,'Spray Shashi',25,'male','3 years','Painter','Gurgaon','9876543265','morning','2026-04-14 18:10:14',450.00,1),(58,156,'Mazdoor Mohan',33,'male','10 years','House Labour','Delhi','9876543266','morning','2026-04-14 18:10:14',450.00,1),(59,157,'Brick Balu',45,'male','25 years','House Labour','Meerut','9876543267','morning','2026-04-14 18:10:14',500.00,10),(60,158,'Stone Sonu',29,'male','6 years','House Labour','Noida','9876543268','morning','2026-04-14 18:10:14',400.00,1),(61,159,'Cement Chaman',38,'male','15 years','House Labour','Delhi','9876543269','morning','2026-04-14 18:10:14',480.00,10),(62,160,'Tiler Tilu',27,'male','5 years','House Labour','Gurgaon','9876543270','morning','2026-04-14 18:10:14',420.00,1),(67,161,'Raju Rastogi',39,'male','2 years','Cook','ghaziabad','9876543271','morning','2026-04-14 19:44:14',250.00,10),(68,162,'Reema Devi',27,'female','7 years','Cook','delhi','9876543272','night','2026-04-14 19:44:14',550.00,10),(69,163,'Shakuntala Rani',41,'female','10 years','Cook','hisar','9876543273','morning','2026-04-14 19:44:14',320.00,10),(70,102,'Sachin',35,'male','5 years','Cook','bihar','9876543274','night','2026-04-14 19:44:14',380.00,10);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('client','staff','agency') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'agency1','pass123','agency','2026-04-01 05:54:14'),(2,'staff1','pass123','staff','2026-04-01 05:54:14'),(3,'client1','pass123','client','2026-04-01 05:54:14'),(7,'client2','pass12345','client','2026-04-01 07:14:33'),(8,'staff_test2','pass123','staff','2026-04-07 07:07:55'),(9,'staff_test1','pass123','staff','2026-04-07 07:08:02'),(10,'agency_test','pass123','agency','2026-04-07 07:08:05'),(13,'client10','pass123','client','2026-04-08 01:15:20'),(16,'yash10','pass123','client','2026-04-08 01:16:09'),(17,'vinayak10','pass123','agency','2026-04-08 01:16:09');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-15  9:58:10
