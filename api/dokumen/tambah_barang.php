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

if (isset($data->nama_barang) && isset($data->kategori)) {
    $nama = $data->nama_barang;
    $kategori = $data->kategori;
    
    // Auto generate kode barang
    $prefix = "NVG-" . strtoupper(substr(preg_replace('/[^A-Za-z]/', '', $kategori), 0, 3)) . "-";
    
    // Get latest count for this prefix
    $q_count = mysqli_query($koneksi, "SELECT COUNT(*) as c FROM barang WHERE kode_barang LIKE '$prefix%'");
    $count = mysqli_fetch_assoc($q_count)['c'] + 1;
    $kode_barang = $prefix . str_pad($count, 3, "0", STR_PAD_LEFT);

    // Insert new barang
    $stmt = $koneksi->prepare("INSERT INTO barang (kode_barang, nama_barang, jenis_kategori, stok_awal, stok_siap_kirim) VALUES (?, ?, ?, 0, 0)");
    $stmt->bind_param("sss", $kode_barang, $nama, $kategori);
    
    if ($stmt->execute()) {
        $new_id = $stmt->insert_id;
        echo json_encode([
            "status" => "success", 
            "message" => "Barang berhasil ditambahkan",
            "data" => [
                "id_barang" => $new_id,
                "kode_barang" => $kode_barang,
                "nama_barang" => $nama
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menambahkan barang: " . $stmt->error]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>
