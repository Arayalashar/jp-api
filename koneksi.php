<?php
// File: koneksi.php

// DATA DARI ALWAYSDATA
$host = "mysql-jpapi.alwaysdata.net"; // Host standar Alwaysdata
$user = "jpapi_jakhi";         // <-- Ganti dengan nama user yang baru kamu buat (pakai awalan jpapi_)
$pass = "jakhipasaribawa";     // <-- Ganti dengan password database yang baru
$db   = "jpapi_db_jp";                // <-- Ganti dengan nama database yang baru (pakai awalan jpapi_)

// Melakukan koneksi
$koneksi = mysqli_connect($host, $user, $pass, $db);

// Cek koneksi
if (!$koneksi) {
    die(json_encode([
        "status" => "error", 
        "message" => "Gagal terhubung ke database: " . mysqli_connect_error()
    ]));
}

// SURAT IZIN CORS (Wajib ada!)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");
?>