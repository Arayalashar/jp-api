<?php
// Izinkan akses CORS untuk Flutter Web
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Tangani sinyal preflight (OPTIONS) dari browser Chrome
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

header("Content-Type: application/json; charset=UTF-8");
require 'koneksi.php';

$data = json_decode(file_get_contents("php://input"));

// Cek apakah data yang dikirim tidak kosong
if (
    isset($data->jenis_dokumen) && isset($data->nomor_dokumen) && 
    isset($data->id_supir) && isset($data->id_barang)
) {
    $jenis_dokumen = mysqli_real_escape_string($koneksi, $data->jenis_dokumen);
    $nomor_dokumen = mysqli_real_escape_string($koneksi, $data->nomor_dokumen);
    $tujuan = mysqli_real_escape_string($koneksi, $data->tujuan);
    $id_supir = $data->id_supir;
    $id_barang = $data->id_barang;
    $jumlah = (int)$data->jumlah;
    $id_admin = $data->id_admin;

    // 1. Simpan ke tabel dokumen
    $query_dok = "INSERT INTO dokumen (nomor_dokumen, jenis_dokumen, id_admin, id_supir, tujuan_pengiriman) 
                  VALUES ('$nomor_dokumen', '$jenis_dokumen', '$id_admin', '$id_supir', '$tujuan')";
    
    if (mysqli_query($koneksi, $query_dok)) {
        $id_dokumen_baru = mysqli_insert_id($koneksi); // Ambil ID dokumen yang baru terbuat
        
        // 2. Simpan ke tabel detail_dokumen
        $query_detail = "INSERT INTO detail_dokumen (id_dokumen, id_barang, jumlah_packing) 
                         VALUES ('$id_dokumen_baru', '$id_barang', '$jumlah')";
        mysqli_query($koneksi, $query_detail);

        echo json_encode(["status" => "success", "message" => "Dokumen berhasil dibuat!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal membuat dokumen: " . mysqli_error($koneksi)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data form tidak lengkap!"]);
}
?>