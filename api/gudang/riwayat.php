<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

require '../../config/database.php';

$id_karyawan = isset($_GET['id_karyawan']) ? (int)$_GET['id_karyawan'] : 0;

$query = "
    SELECT 
        d.id_dokumen, 
        d.nomor_dokumen, 
        d.jenis_dokumen, 
        d.tujuan_pengiriman,
        d.status_pengiriman, 
        d.tanggal_buat,
        u.nama_lengkap AS nama_supir,
        dd.id_barang, 
        b.nama_barang, 
        b.kode_barang, 
        dd.jumlah_packing,
        sl.waktu_selesai
    FROM dokumen d
    INNER JOIN detail_dokumen dd ON d.id_dokumen = dd.id_dokumen
    INNER JOIN barang b ON dd.id_barang = b.id_barang
    LEFT JOIN users u ON d.id_supir = u.id_user
    INNER JOIN sortir_log sl ON d.id_dokumen = sl.id_dokumen
    WHERE d.status_pengiriman != 'Menunggu'
    AND (d.jenis_dokumen LIKE 'Resi Pengi%' OR d.jenis_dokumen = 'Surat Jalan')
";

if ($id_karyawan > 0) {
    $query .= " AND sl.id_karyawan = $id_karyawan";
}

$query .= " ORDER BY sl.waktu_selesai DESC, d.tanggal_buat DESC";

$result = mysqli_query($koneksi, $query);

$data = [];
if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    
    echo json_encode([
        "status" => "success",
        "data" => $data
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => "Gagal mengambil data: " . mysqli_error($koneksi)
    ]);
}

mysqli_close($koneksi);
?>
