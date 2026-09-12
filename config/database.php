<?php
// File: config/database.php

// PENGATURAN INFINITYFREE
$host = "sql312.infinityfree.com"; 
$user = "if0_42895789";         
$pass = "jakhi1112";     
$db   = "if0_42895789_db_jp";               

// Melakukan koneksi
$koneksi = mysqli_connect($host, $user, $pass, $db);

// Cek koneksi
if (!$koneksi) {
    die(json_encode([
        "status" => "error", 
        "message" => "Gagal terhubung ke database: " . mysqli_connect_error()
    ]));
}

// SURAT IZIN CORS (Wajib ada untuk Flutter Web/Localhost)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");
?>
