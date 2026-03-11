<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");

require 'koneksi.php';

// 1. Ambil Summary (Ringkasan)
$q_total = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) as total FROM dokumen"));
$q_selesai = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) as total FROM dokumen WHERE status_pengiriman = 'Sampai Tujuan'"));
$q_gagal = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) as total FROM dokumen WHERE status_pengiriman = 'Gagal Kirim'"));

$summary = [
    "total" => $q_total['total'] ?? 0,
    "selesai" => $q_selesai['total'] ?? 0,
    "gagal" => $q_gagal['total'] ?? 0
];

// 2. Ambil Daftar Dokumen Detail beserta waktu dari tracking
$query_detail = "
    SELECT 
        d.nomor_dokumen, 
        d.jenis_dokumen, 
        d.tujuan_pengiriman, 
        d.status_pengiriman, 
        d.tanggal_buat,
        u.nama_lengkap AS nama_supir,
        
        -- Mengambil waktu_update terakhir dari tabel tracking_pengiriman
        (SELECT t.waktu_update 
         FROM tracking_pengiriman t 
         WHERE t.id_dokumen = d.id_dokumen 
         ORDER BY t.waktu_update DESC LIMIT 1) AS waktu_update
         
    FROM dokumen d
    LEFT JOIN users u ON d.id_supir = u.id_user
    ORDER BY d.tanggal_buat DESC
";

$result = mysqli_query($koneksi, $query_detail);

if (!$result) {
    echo json_encode(["status" => "error", "message" => "Error Query: " . mysqli_error($koneksi)]);
    exit();
}

$data_dokumen = [];
while ($row = mysqli_fetch_assoc($result)) {
    $data_dokumen[] = $row;
}

echo json_encode([
    "status" => "success",
    "summary" => $summary,
    "data" => $data_dokumen
]);
?>