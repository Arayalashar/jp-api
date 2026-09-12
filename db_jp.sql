-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: db_jp
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `barang`
--

DROP TABLE IF EXISTS `barang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `barang` (
  `id_barang` int(11) NOT NULL AUTO_INCREMENT,
  `kode_barang` varchar(20) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `jenis_kategori` varchar(50) DEFAULT NULL,
  `stok_awal` int(11) DEFAULT 0,
  `stok_siap_kirim` int(11) DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_barang`),
  UNIQUE KEY `kode_barang` (`kode_barang`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barang`
--

LOCK TABLES `barang` WRITE;
/*!40000 ALTER TABLE `barang` DISABLE KEYS */;
INSERT INTO `barang` VALUES (1,'NVG-SRM-001','Navagreen Serum Wajah 30ml','Serum',100,31,'2026-02-23 08:26:52'),(2,'NVG-TNR-004','Navagreen Toner 150ml','Toner',100,16,'2026-02-22 06:47:11'),(3,'NVG-CRM-002','Navagreen Day Cream 20g','Krim Wajah',100,100,'2026-09-01 14:47:48'),(4,'NVG-CRM-003','Navagreen Night Cream 20g','Krim Wajah',100,100,'2026-09-01 14:47:48'),(5,'NVG-FWS-001','Navagreen Facial Wash 100ml','Sabun Cuci Muka',150,150,'2026-09-01 14:47:48'),(6,'NVG-SNB-001','Navagreen Sunblock SPF 30','Sunscreen',80,80,'2026-09-01 14:47:48');
/*!40000 ALTER TABLE `barang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detail_dokumen`
--

DROP TABLE IF EXISTS `detail_dokumen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `detail_dokumen` (
  `id_detail` int(11) NOT NULL AUTO_INCREMENT,
  `id_dokumen` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `jumlah_packing` int(11) NOT NULL,
  PRIMARY KEY (`id_detail`),
  KEY `id_dokumen` (`id_dokumen`),
  KEY `id_barang` (`id_barang`),
  CONSTRAINT `detail_dokumen_ibfk_1` FOREIGN KEY (`id_dokumen`) REFERENCES `dokumen` (`id_dokumen`),
  CONSTRAINT `detail_dokumen_ibfk_2` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detail_dokumen`
--

LOCK TABLES `detail_dokumen` WRITE;
/*!40000 ALTER TABLE `detail_dokumen` DISABLE KEYS */;
INSERT INTO `detail_dokumen` VALUES (1,1,1,4),(2,3,1,10),(3,4,1,6),(4,5,2,6),(5,6,1,12),(6,7,1,13),(7,8,2,4),(8,9,2,28),(9,10,1,11),(10,11,1,11),(11,12,1,10),(12,13,1,10),(13,14,2,10),(14,15,2,12),(15,16,2,4),(16,17,1,12),(17,21,2,12),(18,22,1,2);
/*!40000 ALTER TABLE `detail_dokumen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dokumen`
--

DROP TABLE IF EXISTS `dokumen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dokumen` (
  `id_dokumen` int(11) NOT NULL AUTO_INCREMENT,
  `nomor_dokumen` varchar(50) NOT NULL,
  `jenis_dokumen` enum('Resi Pengambilan','Resi Pengiriman','Surat Jalan') NOT NULL,
  `id_admin` int(11) NOT NULL,
  `id_supir` int(11) DEFAULT NULL,
  `tujuan_pengiriman` text NOT NULL,
  `tanggal_buat` datetime DEFAULT current_timestamp(),
  `status_pengiriman` enum('Menunggu','Siap Dikirim','Dalam Perjalanan','Sampai Tujuan','Gagal Kirim') DEFAULT 'Menunggu',
  PRIMARY KEY (`id_dokumen`),
  UNIQUE KEY `nomor_dokumen` (`nomor_dokumen`),
  KEY `id_admin` (`id_admin`),
  KEY `id_supir` (`id_supir`),
  CONSTRAINT `dokumen_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `users` (`id_user`),
  CONSTRAINT `dokumen_ibfk_2` FOREIGN KEY (`id_supir`) REFERENCES `users` (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dokumen`
--

LOCK TABLES `dokumen` WRITE;
/*!40000 ALTER TABLE `dokumen` DISABLE KEYS */;
INSERT INTO `dokumen` VALUES (1,'NVG-2026-01','Resi Pengambilan',1,4,'Jakarta','2026-02-19 16:33:00','Menunggu'),(3,'NVG-2026-02','Resi Pengiriman',1,5,'Jakarta','2026-02-19 16:37:13','Sampai Tujuan'),(4,'IN-001','Resi Pengambilan',1,4,'Pabrik Navagreen Pusat','2026-02-19 16:47:46','Menunggu'),(5,'OUT-001','Resi Pengiriman',1,5,'Klinik Navagreen Cabang Sudirman','2026-02-19 16:50:05','Sampai Tujuan'),(6,'APP-001','Resi Pengiriman',1,4,'Klinik Pusat','2026-02-22 13:07:44','Siap Dikirim'),(7,'OUT-002','Resi Pengiriman',1,5,'Jakarta','2026-02-22 13:28:40','Sampai Tujuan'),(8,'IN-002','Resi Pengambilan',1,4,'Jogja','2026-02-22 13:35:53','Menunggu'),(9,'OUT-004','Resi Pengiriman',1,5,'Bandung','2026-02-22 14:25:19','Sampai Tujuan'),(10,'IN-003','Resi Pengambilan',1,4,'Gudang','2026-02-22 14:33:46','Sampai Tujuan'),(11,'OUT-005','Resi Pengiriman',1,5,'Klinik Jogja','2026-02-22 14:36:28','Sampai Tujuan'),(12,'IN-007','Resi Pengambilan',1,4,'Gudang','2026-02-23 15:26:04','Sampai Tujuan'),(13,'OUT-007','Resi Pengiriman',1,5,'Jakarta','2026-02-23 15:27:20','Sampai Tujuan'),(14,'F-001','Resi Pengiriman',1,5,'Jakarta','2026-02-23 15:37:46','Siap Dikirim'),(15,'F-002','Resi Pengiriman',1,5,'Jakarta','2026-02-23 15:43:16','Siap Dikirim'),(16,'5t5tt','Resi Pengambilan',1,4,'tbttb','2026-02-25 10:19:32','Gagal Kirim'),(17,'F-02','Resi Pengiriman',1,4,'Jogja','2026-09-01 21:08:56','Siap Dikirim'),(21,'F-03','Resi Pengiriman',1,4,'JOgja','2026-09-01 21:19:37','Dalam Perjalanan'),(22,'NVG-202609-396','Resi Pengiriman',1,4,'Jogja','2026-09-01 21:39:47','Sampai Tujuan');
/*!40000 ALTER TABLE `dokumen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifikasi`
--

DROP TABLE IF EXISTS `notifikasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifikasi` (
  `id_notif` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `pesan` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_notif`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `notifikasi_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifikasi`
--

LOCK TABLES `notifikasi` WRITE;
/*!40000 ALTER TABLE `notifikasi` DISABLE KEYS */;
INSERT INTO `notifikasi` VALUES (1,1,'Selamat Datang','Sistem logistik versi terbaru telah berhasil diupdate.',0,'2026-09-04 14:55:48'),(2,1,'Pengiriman Baru','Ada 2 pengiriman baru yang siap diproses hari ini.',0,'2026-09-04 14:55:48');
/*!40000 ALTER TABLE `notifikasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pemeriksaan`
--

DROP TABLE IF EXISTS `pemeriksaan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pemeriksaan` (
  `id_pemeriksaan` int(11) NOT NULL AUTO_INCREMENT,
  `id_barang` int(11) NOT NULL,
  `id_supervisor` int(11) NOT NULL,
  `tanggal_pemeriksaan` datetime DEFAULT current_timestamp(),
  `jumlah_datang` int(11) NOT NULL,
  `jumlah_bagus` int(11) NOT NULL,
  `jumlah_rusak` int(11) NOT NULL,
  `status_pemeriksaan` enum('Lengkap','Kurang','Rusak','Perlu Penanganan') NOT NULL,
  `catatan` text DEFAULT NULL,
  PRIMARY KEY (`id_pemeriksaan`),
  KEY `id_barang` (`id_barang`),
  KEY `id_supervisor` (`id_supervisor`),
  CONSTRAINT `pemeriksaan_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`),
  CONSTRAINT `pemeriksaan_ibfk_2` FOREIGN KEY (`id_supervisor`) REFERENCES `users` (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pemeriksaan`
--

LOCK TABLES `pemeriksaan` WRITE;
/*!40000 ALTER TABLE `pemeriksaan` DISABLE KEYS */;
INSERT INTO `pemeriksaan` VALUES (1,1,2,'2026-02-19 16:48:36',6,4,-2,'Rusak',''),(2,2,2,'2026-02-22 13:36:17',4,4,0,'Lengkap',''),(3,2,2,'2026-02-22 13:36:21',4,4,0,'Lengkap',''),(4,1,2,'2026-02-22 13:36:38',6,6,4,'Rusak',''),(5,2,2,'2026-02-22 13:38:21',4,4,3,'Rusak',''),(6,2,2,'2026-02-22 13:47:11',4,4,2,'Rusak',''),(7,1,2,'2026-02-22 14:34:42',11,11,0,'Lengkap',''),(8,1,2,'2026-02-23 15:26:52',10,10,0,'Lengkap','');
/*!40000 ALTER TABLE `pemeriksaan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sortir_log`
--

DROP TABLE IF EXISTS `sortir_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sortir_log` (
  `id_sortir` int(11) NOT NULL AUTO_INCREMENT,
  `id_dokumen` int(11) NOT NULL,
  `id_karyawan` int(11) NOT NULL,
  `berat_total` decimal(10,2) DEFAULT NULL,
  `jumlah_koli` int(11) DEFAULT NULL,
  `keterangan_packing` text DEFAULT NULL,
  `waktu_selesai` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_sortir`),
  KEY `id_dokumen` (`id_dokumen`),
  KEY `id_karyawan` (`id_karyawan`),
  CONSTRAINT `sortir_log_ibfk_1` FOREIGN KEY (`id_dokumen`) REFERENCES `dokumen` (`id_dokumen`),
  CONSTRAINT `sortir_log_ibfk_2` FOREIGN KEY (`id_karyawan`) REFERENCES `users` (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sortir_log`
--

LOCK TABLES `sortir_log` WRITE;
/*!40000 ALTER TABLE `sortir_log` DISABLE KEYS */;
INSERT INTO `sortir_log` VALUES (1,3,3,0.10,1,'','2026-02-19 16:37:36'),(2,5,3,2.50,3,'','2026-02-19 16:50:55'),(3,13,3,NULL,NULL,'Selesai dipacking dan siap diserahkan ke supir','2026-02-23 15:27:42'),(4,6,3,NULL,NULL,'Selesai dipacking dan siap diserahkan ke supir','2026-02-23 15:27:49'),(5,14,3,NULL,NULL,'Selesai dipacking dan siap diserahkan ke supir','2026-02-23 15:38:01'),(6,15,3,NULL,NULL,'Selesai dipacking dan siap diserahkan ke supir','2026-02-23 15:43:32'),(7,21,3,NULL,NULL,'Selesai dipacking dan siap diserahkan ke supir','2026-09-01 21:19:55'),(8,17,3,NULL,NULL,'Selesai dipacking dan siap diserahkan ke supir','2026-09-01 21:19:57'),(9,22,3,NULL,NULL,'Selesai dipacking dan siap diserahkan ke supir','2026-09-01 21:40:22');
/*!40000 ALTER TABLE `sortir_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracking_pengiriman`
--

DROP TABLE IF EXISTS `tracking_pengiriman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tracking_pengiriman` (
  `id_tracking` int(11) NOT NULL AUTO_INCREMENT,
  `id_dokumen` int(11) NOT NULL,
  `status_log` enum('Dalam Perjalanan','Sampai Tujuan','Gagal Kirim') NOT NULL,
  `waktu_update` datetime DEFAULT current_timestamp(),
  `bukti_foto` varchar(255) DEFAULT NULL,
  `keterangan_gagal` text DEFAULT NULL,
  `koordinat_lokasi` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_tracking`),
  KEY `id_dokumen` (`id_dokumen`),
  CONSTRAINT `tracking_pengiriman_ibfk_1` FOREIGN KEY (`id_dokumen`) REFERENCES `dokumen` (`id_dokumen`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracking_pengiriman`
--

LOCK TABLES `tracking_pengiriman` WRITE;
/*!40000 ALTER TABLE `tracking_pengiriman` DISABLE KEYS */;
INSERT INTO `tracking_pengiriman` VALUES (1,5,'Dalam Perjalanan','2026-02-19 16:51:37',NULL,'',NULL),(2,5,'Sampai Tujuan','2026-02-19 16:51:43',NULL,'',NULL),(3,3,'Sampai Tujuan','2026-02-22 13:27:13',NULL,'',NULL),(4,7,'Sampai Tujuan','2026-02-22 13:29:05',NULL,'Arya',NULL),(5,9,'','2026-02-22 14:25:47',NULL,'Selesai dipacking oleh Karyawan Gudang',NULL),(6,9,'','2026-02-22 14:25:53',NULL,'Selesai dipacking oleh Karyawan Gudang',NULL),(7,9,'Sampai Tujuan','2026-02-22 14:26:20',NULL,'Arya',NULL),(8,6,'','2026-02-22 14:30:17',NULL,'Selesai dipacking oleh Karyawan Gudang',NULL),(9,10,'Sampai Tujuan','2026-02-22 14:34:15',NULL,'',NULL),(10,6,'','2026-02-22 14:35:00',NULL,'Selesai dipacking oleh Karyawan Gudang',NULL),(11,6,'','2026-02-22 14:35:18',NULL,'Selesai dipacking oleh Karyawan Gudang',NULL),(14,12,'Sampai Tujuan','2026-02-23 15:26:26',NULL,'',NULL),(15,13,'Sampai Tujuan','2026-02-23 15:28:15',NULL,'',NULL),(16,22,'Sampai Tujuan','2026-09-01 21:40:54',NULL,'',NULL),(17,21,'Dalam Perjalanan','2026-09-01 21:40:58',NULL,'',NULL),(18,16,'Gagal Kirim','2026-09-01 21:41:07',NULL,'',NULL);
/*!40000 ALTER TABLE `tracking_pengiriman` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `role` enum('admin','supervisor','karyawan_gudang','supir') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','Admin123',' Admin','admin','2026-02-19 08:57:25'),(2,'Supervisor','Supervisor123','Supervisor','supervisor','2026-02-19 08:57:25'),(3,'Karyawan','Karyawan123','Karyawan','karyawan_gudang','2026-02-19 08:57:25'),(4,'PickUp','Pick Up123','Supir Pick up','supir','2026-02-19 08:57:25'),(5,'Delivery','Delivery123',' Supir Delivery','supir','2026-02-19 08:57:25');
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

-- Dump completed on 2026-09-04 21:56:26
