<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200); exit();
}

header("Content-Type: application/json; charset=UTF-8");
require 'koneksi.php';
$data = json_decode(file_get_contents("php://input"));

if(isset($data->id_dokumen) && isset($data->id_barang)) {
    $id_barang = $data->id_barang;
    $id_spv = $data->id_spv;
    $jml_datang = (int)$data->jumlah_diharapkan;
    $jml_bagus = (int)$data->jumlah_bagus;
    $jml_rusak = (int)$data->jumlah_rusak;
    $status = mysqli_real_escape_string($koneksi, $data->status_pemeriksaan);
    $catatan = mysqli_real_escape_string($koneksi, $data->catatan);

    // 1. Simpan riwayat pemeriksaan
    $q_insert = "INSERT INTO pemeriksaan (id_barang, id_supervisor, jumlah_datang, jumlah_bagus, jumlah_rusak, status_pemeriksaan, catatan) 
                 VALUES ('$id_barang', '$id_spv', '$jml_datang', '$jml_bagus', '$jml_rusak', '$status', '$catatan')";
    
    if(mysqli_query($koneksi, $q_insert)){
        // 2. Update stok barang di gudang (hanya barang bagus yang dihitung)
        mysqli_query($koneksi, "UPDATE barang SET stok_siap_kirim = stok_siap_kirim + $jml_bagus WHERE id_barang = '$id_barang'");
        echo json_encode(["status" => "success", "message" => "Pemeriksaan berhasil! Stok gudang telah bertambah."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menyimpan: " . mysqli_error($koneksi)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data form tidak lengkap"]);
}
?>