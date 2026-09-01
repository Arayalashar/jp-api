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

if(isset($data->id_barang) && isset($data->id_spv) && isset($data->id_dokumen)) {
    $id_barang = $data->id_barang;
    $id_spv = $data->id_spv;
    $id_dokumen = $data->id_dokumen; 
    $jml_datang = (int)$data->jumlah_diharapkan;
    $jml_bagus = (int)$data->jumlah_bagus;
    $jml_rusak = (int)$data->jumlah_rusak;
    $status = $data->status_pemeriksaan;
    $catatan = $data->catatan;

    $stmt = $koneksi->prepare("INSERT INTO pemeriksaan (id_dokumen, id_barang, id_supervisor, jumlah_datang, jumlah_bagus, jumlah_rusak, status_pemeriksaan, catatan) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("iiiiiiss", $id_dokumen, $id_barang, $id_spv, $jml_datang, $jml_bagus, $jml_rusak, $status, $catatan);
    
    if($stmt->execute()){
        $stmt->close();
        
        $stmt_update = $koneksi->prepare("UPDATE barang SET stok_siap_kirim = stok_siap_kirim + ? WHERE id_barang = ?");
        $stmt_update->bind_param("ii", $jml_bagus, $id_barang);
        $stmt_update->execute();
        $stmt_update->close();
        
        echo json_encode(["status" => "success", "message" => "Pemeriksaan berhasil!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menyimpan: " . $stmt->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data form tidak lengkap"]);
}
?>
