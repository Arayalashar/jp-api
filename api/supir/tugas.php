<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require '../../config/database.php';

$id_supir = isset($_GET['id_supir']) ? (int)$_GET['id_supir'] : 0;

if ($id_supir > 0) {
    $stmt = $koneksi->prepare("SELECT id_dokumen, nomor_dokumen, jenis_dokumen, tanggal_buat, tujuan_pengiriman, status_pengiriman FROM dokumen WHERE id_supir = ? ORDER BY tanggal_buat DESC");
    $stmt->bind_param("i", $id_supir);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    $stmt->close();
    echo json_encode(["status" => "success", "data" => $data]);
} else {
    echo json_encode(["status" => "error", "message" => "ID Supir tidak valid atau tidak ditemukan"]);
}
?>
