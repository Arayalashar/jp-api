<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

error_reporting(0);
header("Content-Type: application/json; charset=UTF-8");
require '../../config/database.php';
require '../config/helpers_notif.php';

$data = json_decode(file_get_contents("php://input"));

if(isset($data->id_dokumen) && isset($data->status)) {
    $id_dokumen = (int)$data->id_dokumen;
    $status = $data->status;
    $keterangan = $data->keterangan ?? '';

    // 1. Update status di tabel dokumen
    $stmt_update = $koneksi->prepare("UPDATE dokumen SET status_pengiriman = ? WHERE id_dokumen = ?");
    $stmt_update->bind_param("si", $status, $id_dokumen);
    $update_success = $stmt_update->execute();
    $stmt_update->close();

    // 2. Catat riwayat di tabel tracking
    $stmt_tracking = $koneksi->prepare("INSERT INTO tracking_pengiriman (id_dokumen, status_log, keterangan_gagal) VALUES (?, ?, ?)");
    $stmt_tracking->bind_param("iss", $id_dokumen, $status, $keterangan);
    $track_success = $stmt_tracking->execute();
    $stmt_tracking->close();

    if($update_success && $track_success) {
        if($status === 'Sampai Tujuan') {
            // Dapatkan nomor_dokumen
            $stmt_dok = $koneksi->prepare("SELECT nomor_dokumen FROM dokumen WHERE id_dokumen = ?");
            if($stmt_dok) {
                $stmt_dok->bind_param("i", $id_dokumen);
                $stmt_dok->execute();
                $res_dok = $stmt_dok->get_result();
                if($row_dok = $res_dok->fetch_assoc()){
                    buat_notifikasi_role($koneksi, 'supervisor', 'Tugas Inspeksi Baru', "Dokumen {$row_dok['nomor_dokumen']} telah sampai tujuan dan siap untuk diinspeksi QC.");
                }
                $stmt_dok->close();
            }
        }
        echo json_encode(["status" => "success", "message" => "Status berhasil diperbarui!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal memproses data"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>
