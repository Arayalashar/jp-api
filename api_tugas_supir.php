<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require 'koneksi.php';

// Menangkap ID Supir dari URL (GET)
$id_supir = isset($_GET['id_supir']) ? $_GET['id_supir'] : '';

if ($id_supir != '') {
    // Ambil dokumen yang id_supir-nya cocok
    $query = "SELECT id_dokumen, nomor_dokumen, jenis_dokumen, tanggal_buat, tujuan_pengiriman, status_pengiriman 
              FROM dokumen 
              WHERE id_supir = '$id_supir' 
              ORDER BY tanggal_buat DESC";
    $result = mysqli_query($koneksi, $query);
    
    $data = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $data]);
} else {
    echo json_encode(["status" => "error", "message" => "ID Supir tidak ditemukan"]);
}
?>