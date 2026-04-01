<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require 'koneksi.php';

$query = "
    SELECT 
        p.id_pemeriksaan, 
        b.nama_barang, 
        b.kode_barang, 
        p.jumlah_datang, 
        p.jumlah_bagus, 
        p.jumlah_rusak, 
        p.status_pemeriksaan, 
        p.catatan, 
        u.nama_lengkap AS nama_spv,
        p.tanggal_pemeriksaan
    FROM pemeriksaan p
    LEFT JOIN barang b ON p.id_barang = b.id_barang
    LEFT JOIN users u ON p.id_supervisor = u.id_user
    ORDER BY p.tanggal_pemeriksaan DESC
";

$result = mysqli_query($koneksi, $query);

if (!$result) {
    echo json_encode(["status" => "error", "message" => "Error Query: " . mysqli_error($koneksi)]);
    exit();
}

$data = [];
while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode(["status" => "success", "data" => $data]);
?>