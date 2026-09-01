<?php
// File: config/database.php

// PENGATURAN LOCALHOST (XAMPP)
$host = "localhost"; 
$user = "root";         
$pass = "";     
$db   = "db_jp"; // Pastikan Anda sudah mengimpor db_jp.sql di phpMyAdmin lokal Anda!               

// Melakukan koneksi
$koneksi = mysqli_connect($host, $user, $pass, $db);

// Cek koneksi
if (!$koneksi) {
    die(json_encode([
        "status" => "error", 
        "message" => "Gagal terhubung ke database lokal: " . mysqli_connect_error()
    ]));
}

// SURAT IZIN CORS (Wajib ada untuk Flutter Web/Localhost)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");
?>
