<?php
// File: koneksi.php

// DATA DARI ALWAYSDATA
$host = "mysql-jpapi.alwaysdata.net"; 
$user = "jpapi_jakhi";         
$pass = "jakhipasaribawa";     
$db   = "jpapi_db_jp";                

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