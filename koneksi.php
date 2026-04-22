<?php

// DATA DARI INFINITYFREE
$host = "sql208.infinityfree.com";
$user = "if0_41701669";
$pass = "AZRy77k8ac8 "; 
$db   = "if0_41701669_db_jp";

// Melakukan koneksi
$koneksi = mysqli_connect($host, $user, $pass, $db);

// Cek koneksi
if (!$koneksi) {
    die(json_encode([
        "status" => "error", 
        "message" => "Gagal terhubung ke database: " . mysqli_connect_error()
    ]));
}

// WAJIB DITAMBAHKAN AGAR FLUTTER BISA MEMBACA DATANYA
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");
?>