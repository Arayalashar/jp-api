-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 23, 2026 at 09:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_jp`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(11) NOT NULL,
  `kode_barang` varchar(20) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `jenis_kategori` varchar(50) DEFAULT NULL,
  `stok_awal` int(11) DEFAULT 0,
  `stok_siap_kirim` int(11) DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `kode_barang`, `nama_barang`, `jenis_kategori`, `stok_awal`, `stok_siap_kirim`, `updated_at`) VALUES
(1, 'NVG-SRM-001', 'Navagreen Serum Wajah 30ml', 'Serum', 100, 31, '2026-02-23 08:26:52'),
(2, 'NVG-TNR-004', 'Navagreen Toner 150ml', 'Toner', 100, 16, '2026-02-22 06:47:11');

-- --------------------------------------------------------

--
-- Table structure for table `detail_dokumen`
--

CREATE TABLE `detail_dokumen` (
  `id_detail` int(11) NOT NULL,
  `id_dokumen` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `jumlah_packing` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_dokumen`
--

INSERT INTO `detail_dokumen` (`id_detail`, `id_dokumen`, `id_barang`, `jumlah_packing`) VALUES
(1, 1, 1, 4),
(2, 3, 1, 10),
(3, 4, 1, 6),
(4, 5, 2, 6),
(5, 6, 1, 12),
(6, 7, 1, 13),
(7, 8, 2, 4),
(8, 9, 2, 28),
(9, 10, 1, 11),
(10, 11, 1, 11),
(11, 12, 1, 10),
(12, 13, 1, 10),
(13, 14, 2, 10),
(14, 15, 2, 12);

-- --------------------------------------------------------

--
-- Table structure for table `dokumen`
--

CREATE TABLE `dokumen` (
  `id_dokumen` int(11) NOT NULL,
  `nomor_dokumen` varchar(50) NOT NULL,
  `jenis_dokumen` enum('Resi Pengambilan','Resi Pengiriman','Surat Jalan') NOT NULL,
  `id_admin` int(11) NOT NULL,
  `id_supir` int(11) DEFAULT NULL,
  `tujuan_pengiriman` text NOT NULL,
  `tanggal_buat` datetime DEFAULT current_timestamp(),
  `status_pengiriman` enum('Menunggu','Siap Dikirim','Dalam Perjalanan','Sampai Tujuan','Gagal Kirim') DEFAULT 'Menunggu'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokumen`
--

INSERT INTO `dokumen` (`id_dokumen`, `nomor_dokumen`, `jenis_dokumen`, `id_admin`, `id_supir`, `tujuan_pengiriman`, `tanggal_buat`, `status_pengiriman`) VALUES
(1, 'NVG-2026-01', 'Resi Pengambilan', 1, 4, 'Jakarta', '2026-02-19 16:33:00', 'Menunggu'),
(3, 'NVG-2026-02', 'Resi Pengiriman', 1, 5, 'Jakarta', '2026-02-19 16:37:13', 'Sampai Tujuan'),
(4, 'IN-001', 'Resi Pengambilan', 1, 4, 'Pabrik Navagreen Pusat', '2026-02-19 16:47:46', 'Menunggu'),
(5, 'OUT-001', 'Resi Pengiriman', 1, 5, 'Klinik Navagreen Cabang Sudirman', '2026-02-19 16:50:05', 'Sampai Tujuan'),
(6, 'APP-001', 'Resi Pengiriman', 1, 4, 'Klinik Pusat', '2026-02-22 13:07:44', 'Siap Dikirim'),
(7, 'OUT-002', 'Resi Pengiriman', 1, 5, 'Jakarta', '2026-02-22 13:28:40', 'Sampai Tujuan'),
(8, 'IN-002', 'Resi Pengambilan', 1, 4, 'Jogja', '2026-02-22 13:35:53', 'Menunggu'),
(9, 'OUT-004', 'Resi Pengiriman', 1, 5, 'Bandung', '2026-02-22 14:25:19', 'Sampai Tujuan'),
(10, 'IN-003', 'Resi Pengambilan', 1, 4, 'Gudang', '2026-02-22 14:33:46', 'Sampai Tujuan'),
(11, 'OUT-005', 'Resi Pengiriman', 1, 5, 'Klinik Jogja', '2026-02-22 14:36:28', 'Sampai Tujuan'),
(12, 'IN-007', 'Resi Pengambilan', 1, 4, 'Gudang', '2026-02-23 15:26:04', 'Sampai Tujuan'),
(13, 'OUT-007', 'Resi Pengiriman', 1, 5, 'Jakarta', '2026-02-23 15:27:20', 'Sampai Tujuan'),
(14, 'F-001', 'Resi Pengiriman', 1, 5, 'Jakarta', '2026-02-23 15:37:46', 'Siap Dikirim'),
(15, 'F-002', 'Resi Pengiriman', 1, 5, 'Jakarta', '2026-02-23 15:43:16', 'Siap Dikirim');

-- --------------------------------------------------------

--
-- Table structure for table `pemeriksaan`
--

CREATE TABLE `pemeriksaan` (
  `id_pemeriksaan` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `id_supervisor` int(11) NOT NULL,
  `tanggal_pemeriksaan` datetime DEFAULT current_timestamp(),
  `jumlah_datang` int(11) NOT NULL,
  `jumlah_bagus` int(11) NOT NULL,
  `jumlah_rusak` int(11) NOT NULL,
  `status_pemeriksaan` enum('Lengkap','Kurang','Rusak','Perlu Penanganan') NOT NULL,
  `catatan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pemeriksaan`
--

INSERT INTO `pemeriksaan` (`id_pemeriksaan`, `id_barang`, `id_supervisor`, `tanggal_pemeriksaan`, `jumlah_datang`, `jumlah_bagus`, `jumlah_rusak`, `status_pemeriksaan`, `catatan`) VALUES
(1, 1, 2, '2026-02-19 16:48:36', 6, 4, -2, 'Rusak', ''),
(2, 2, 2, '2026-02-22 13:36:17', 4, 4, 0, 'Lengkap', ''),
(3, 2, 2, '2026-02-22 13:36:21', 4, 4, 0, 'Lengkap', ''),
(4, 1, 2, '2026-02-22 13:36:38', 6, 6, 4, 'Rusak', ''),
(5, 2, 2, '2026-02-22 13:38:21', 4, 4, 3, 'Rusak', ''),
(6, 2, 2, '2026-02-22 13:47:11', 4, 4, 2, 'Rusak', ''),
(7, 1, 2, '2026-02-22 14:34:42', 11, 11, 0, 'Lengkap', ''),
(8, 1, 2, '2026-02-23 15:26:52', 10, 10, 0, 'Lengkap', '');

-- --------------------------------------------------------

--
-- Table structure for table `sortir_log`
--

CREATE TABLE `sortir_log` (
  `id_sortir` int(11) NOT NULL,
  `id_dokumen` int(11) NOT NULL,
  `id_karyawan` int(11) NOT NULL,
  `berat_total` decimal(10,2) DEFAULT NULL,
  `jumlah_koli` int(11) DEFAULT NULL,
  `keterangan_packing` text DEFAULT NULL,
  `waktu_selesai` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sortir_log`
--

INSERT INTO `sortir_log` (`id_sortir`, `id_dokumen`, `id_karyawan`, `berat_total`, `jumlah_koli`, `keterangan_packing`, `waktu_selesai`) VALUES
(1, 3, 3, 0.10, 1, '', '2026-02-19 16:37:36'),
(2, 5, 3, 2.50, 3, '', '2026-02-19 16:50:55'),
(3, 13, 3, NULL, NULL, 'Selesai dipacking dan siap diserahkan ke supir', '2026-02-23 15:27:42'),
(4, 6, 3, NULL, NULL, 'Selesai dipacking dan siap diserahkan ke supir', '2026-02-23 15:27:49'),
(5, 14, 3, NULL, NULL, 'Selesai dipacking dan siap diserahkan ke supir', '2026-02-23 15:38:01'),
(6, 15, 3, NULL, NULL, 'Selesai dipacking dan siap diserahkan ke supir', '2026-02-23 15:43:32');

-- --------------------------------------------------------

--
-- Table structure for table `tracking_pengiriman`
--

CREATE TABLE `tracking_pengiriman` (
  `id_tracking` int(11) NOT NULL,
  `id_dokumen` int(11) NOT NULL,
  `status_log` enum('Dalam Perjalanan','Sampai Tujuan','Gagal Kirim') NOT NULL,
  `waktu_update` datetime DEFAULT current_timestamp(),
  `bukti_foto` varchar(255) DEFAULT NULL,
  `keterangan_gagal` text DEFAULT NULL,
  `koordinat_lokasi` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tracking_pengiriman`
--

INSERT INTO `tracking_pengiriman` (`id_tracking`, `id_dokumen`, `status_log`, `waktu_update`, `bukti_foto`, `keterangan_gagal`, `koordinat_lokasi`) VALUES
(1, 5, 'Dalam Perjalanan', '2026-02-19 16:51:37', NULL, '', NULL),
(2, 5, 'Sampai Tujuan', '2026-02-19 16:51:43', NULL, '', NULL),
(3, 3, 'Sampai Tujuan', '2026-02-22 13:27:13', NULL, '', NULL),
(4, 7, 'Sampai Tujuan', '2026-02-22 13:29:05', NULL, 'Arya', NULL),
(5, 9, '', '2026-02-22 14:25:47', NULL, 'Selesai dipacking oleh Karyawan Gudang', NULL),
(6, 9, '', '2026-02-22 14:25:53', NULL, 'Selesai dipacking oleh Karyawan Gudang', NULL),
(7, 9, 'Sampai Tujuan', '2026-02-22 14:26:20', NULL, 'Arya', NULL),
(8, 6, '', '2026-02-22 14:30:17', NULL, 'Selesai dipacking oleh Karyawan Gudang', NULL),
(9, 10, 'Sampai Tujuan', '2026-02-22 14:34:15', NULL, '', NULL),
(10, 6, '', '2026-02-22 14:35:00', NULL, 'Selesai dipacking oleh Karyawan Gudang', NULL),
(11, 6, '', '2026-02-22 14:35:18', NULL, 'Selesai dipacking oleh Karyawan Gudang', NULL),
(14, 12, 'Sampai Tujuan', '2026-02-23 15:26:26', NULL, '', NULL),
(15, 13, 'Sampai Tujuan', '2026-02-23 15:28:15', NULL, '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `role` enum('admin','supervisor','karyawan_gudang','supir') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `username`, `password`, `nama_lengkap`, `role`, `created_at`) VALUES
(1, 'admin', '123456', 'Arya Admin', 'admin', '2026-02-19 08:57:25'),
(2, 'spv', '123456', 'Arya Supervisor', 'supervisor', '2026-02-19 08:57:25'),
(3, 'gudang', '123456', 'Arya Gudang', 'karyawan_gudang', '2026-02-19 08:57:25'),
(4, 'supir1', '123456', 'Arya Supir Pickup', 'supir', '2026-02-19 08:57:25'),
(5, 'supir2', '123456', 'Arya Supir Delivery', 'supir', '2026-02-19 08:57:25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`),
  ADD UNIQUE KEY `kode_barang` (`kode_barang`);

--
-- Indexes for table `detail_dokumen`
--
ALTER TABLE `detail_dokumen`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_dokumen` (`id_dokumen`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `dokumen`
--
ALTER TABLE `dokumen`
  ADD PRIMARY KEY (`id_dokumen`),
  ADD UNIQUE KEY `nomor_dokumen` (`nomor_dokumen`),
  ADD KEY `id_admin` (`id_admin`),
  ADD KEY `id_supir` (`id_supir`);

--
-- Indexes for table `pemeriksaan`
--
ALTER TABLE `pemeriksaan`
  ADD PRIMARY KEY (`id_pemeriksaan`),
  ADD KEY `id_barang` (`id_barang`),
  ADD KEY `id_supervisor` (`id_supervisor`);

--
-- Indexes for table `sortir_log`
--
ALTER TABLE `sortir_log`
  ADD PRIMARY KEY (`id_sortir`),
  ADD KEY `id_dokumen` (`id_dokumen`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- Indexes for table `tracking_pengiriman`
--
ALTER TABLE `tracking_pengiriman`
  ADD PRIMARY KEY (`id_tracking`),
  ADD KEY `id_dokumen` (`id_dokumen`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `detail_dokumen`
--
ALTER TABLE `detail_dokumen`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `dokumen`
--
ALTER TABLE `dokumen`
  MODIFY `id_dokumen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `pemeriksaan`
--
ALTER TABLE `pemeriksaan`
  MODIFY `id_pemeriksaan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `sortir_log`
--
ALTER TABLE `sortir_log`
  MODIFY `id_sortir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tracking_pengiriman`
--
ALTER TABLE `tracking_pengiriman`
  MODIFY `id_tracking` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_dokumen`
--
ALTER TABLE `detail_dokumen`
  ADD CONSTRAINT `detail_dokumen_ibfk_1` FOREIGN KEY (`id_dokumen`) REFERENCES `dokumen` (`id_dokumen`),
  ADD CONSTRAINT `detail_dokumen_ibfk_2` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`);

--
-- Constraints for table `dokumen`
--
ALTER TABLE `dokumen`
  ADD CONSTRAINT `dokumen_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `users` (`id_user`),
  ADD CONSTRAINT `dokumen_ibfk_2` FOREIGN KEY (`id_supir`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `pemeriksaan`
--
ALTER TABLE `pemeriksaan`
  ADD CONSTRAINT `pemeriksaan_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`),
  ADD CONSTRAINT `pemeriksaan_ibfk_2` FOREIGN KEY (`id_supervisor`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `sortir_log`
--
ALTER TABLE `sortir_log`
  ADD CONSTRAINT `sortir_log_ibfk_1` FOREIGN KEY (`id_dokumen`) REFERENCES `dokumen` (`id_dokumen`),
  ADD CONSTRAINT `sortir_log_ibfk_2` FOREIGN KEY (`id_karyawan`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `tracking_pengiriman`
--
ALTER TABLE `tracking_pengiriman`
  ADD CONSTRAINT `tracking_pengiriman_ibfk_1` FOREIGN KEY (`id_dokumen`) REFERENCES `dokumen` (`id_dokumen`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
