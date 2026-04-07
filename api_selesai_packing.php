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

if(isset($data->id_dokumen) && isset($data->id_karyawan)) {
    $id_dokumen = $data->id_dokumen;
    $id_karyawan = $data->id_karyawan;

    // 1. Ubah status dokumen menjadi 'Siap Dikirim'
    $q_update = "UPDATE dokumen SET status_pengiriman = 'Siap Dikirim' WHERE id_dokumen = '$id_dokumen'";
    
    // 2. Catat ke tabel sortir_log
    $q_log = "INSERT INTO sortir_log (id_dokumen, id_karyawan, keterangan_packing) 
              VALUES ('$id_dokumen', '$id_karyawan', 'Selesai dipacking dan siap diserahkan ke supir')";

    if(mysqli_query($koneksi, $q_update) && mysqli_query($koneksi, $q_log)) {
        echo json_encode(["status" => "success", "message" => "Barang berhasil dipacking dan Siap Dikirim!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal: " . mysqli_error($koneksi)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap!"]);
}
?>