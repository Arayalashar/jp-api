<?php
// Izinkan akses CORS untuk Flutter Web
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");

require 'koneksi.php';

// 1. Ambil Data Supir
$query_supir = "SELECT id_user, nama_lengkap FROM users WHERE role = 'supir'";
$result_supir = mysqli_query($koneksi, $query_supir);
$data_supir = [];
while ($row = mysqli_fetch_assoc($result_supir)) {
    $data_supir[] = $row;
}

// 2. Ambil Data Barang
$query_barang = "SELECT id_barang, kode_barang, nama_barang FROM barang";
$result_barang = mysqli_query($koneksi, $query_barang);
$data_barang = [];
while ($row = mysqli_fetch_assoc($result_barang)) {
    $data_barang[] = $row;
}

// Kirimkan sebagai JSON
echo json_encode([
    "status" => "success",
    "data_supir" => $data_supir,
    "data_barang" => $data_barang
]);
?>