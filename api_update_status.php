<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

header("Content-Type: application/json; charset=UTF-8");
require 'koneksi.php';

$data = json_decode(file_get_contents("php://input"));

if(isset($data->id_dokumen) && isset($data->status)) {
    $id_dokumen = $data->id_dokumen;
    $status = mysqli_real_escape_string($koneksi, $data->status);
    $keterangan = mysqli_real_escape_string($koneksi, $data->keterangan);

    // 1. Update status di tabel dokumen
    $query_update = "UPDATE dokumen SET status_pengiriman = '$status' WHERE id_dokumen = '$id_dokumen'";
    // 2. Catat riwayat di tabel tracking
    $query_tracking = "INSERT INTO tracking_pengiriman (id_dokumen, status_log, keterangan_gagal) 
                       VALUES ('$id_dokumen', '$status', '$keterangan')";

    if(mysqli_query($koneksi, $query_update) && mysqli_query($koneksi, $query_tracking)) {
        echo json_encode(["status" => "success", "message" => "Status berhasil diperbarui!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal: " . mysqli_error($koneksi)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>