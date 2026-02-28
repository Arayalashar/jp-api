<?php
// File: koneksi.php

$host = "localhost";
$user = "root";
$pass = "";
$db   = "db_jp";

// Melakukan koneksi
$koneksi = mysqli_connect($host, $user, $pass, $db);

// Cek koneksi
if (!$koneksi) {
    die("Gagal terhubung ke database: " . mysqli_connect_error());
}
?>