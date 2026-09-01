<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200); exit();
}

header("Content-Type: application/json; charset=UTF-8");
require '../../config/database.php';
$data = json_decode(file_get_contents("php://input"));

if(isset($data->id_dokumen) && isset($data->id_karyawan)) {
    $id_dokumen = (int)$data->id_dokumen;
    $id_karyawan = (int)$data->id_karyawan;

    // Menggunakan prepared statement
    $stmt_update = $koneksi->prepare("UPDATE dokumen SET status_pengiriman = 'Siap Dikirim' WHERE id_dokumen = ?");
    $stmt_update->bind_param("i", $id_dokumen);
    $update_success = $stmt_update->execute();
    $stmt_update->close();
    
    $stmt_log = $koneksi->prepare("INSERT INTO sortir_log (id_dokumen, id_karyawan, keterangan_packing) VALUES (?, ?, 'Selesai dipacking dan siap diserahkan ke supir')");
    $stmt_log->bind_param("ii", $id_dokumen, $id_karyawan);
    $log_success = $stmt_log->execute();
    $stmt_log->close();

    if($update_success && $log_success) {
        echo json_encode(["status" => "success", "message" => "Barang berhasil dipacking dan Siap Dikirim!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal memproses data"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap!"]);
}
?>
