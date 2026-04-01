<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require 'koneksi.php';

// Mengambil daftar dokumen khusus "Resi Pengambilan" beserta detail barangnya
$query = "
    SELECT d.id_dokumen, d.nomor_dokumen, d.tanggal_buat, d.status_pengiriman,
           u.nama_lengkap AS supir,
           dd.id_barang, b.nama_barang, dd.jumlah_packing as jumlah_diharapkan
    FROM dokumen d
    LEFT JOIN users u ON d.id_supir = u.id_user
    JOIN detail_dokumen dd ON d.id_dokumen = dd.id_dokumen
    JOIN barang b ON dd.id_barang = b.id_barang
    WHERE d.jenis_dokumen = 'Resi Pengambilan'
    ORDER BY d.tanggal_buat DESC
";
$result = mysqli_query($koneksi, $query);

$data = [];
while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode(["status" => "success", "data" => $data]);
?>