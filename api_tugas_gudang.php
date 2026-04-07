<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require 'koneksi.php';

// Menampilkan dokumen yang berstatus 'Menunggu' DAN 'Siap Dikirim'
$query = "
    SELECT d.id_dokumen, d.nomor_dokumen, d.jenis_dokumen, d.tujuan_pengiriman, 
           d.status_pengiriman, u.nama_lengkap AS nama_supir,
           dd.id_barang, b.nama_barang, b.kode_barang, dd.jumlah_packing
    FROM dokumen d
    JOIN detail_dokumen dd ON d.id_dokumen = dd.id_dokumen
    JOIN barang b ON dd.id_barang = b.id_barang
    LEFT JOIN users u ON d.id_supir = u.id_user
    WHERE d.jenis_dokumen IN ('Resi Pengiriman', 'Surat Jalan')
    -- IZINKAN 'Menunggu' dan 'Siap Dikirim' UNTUK TAMPIL
    AND (d.status_pengiriman IS NULL OR d.status_pengiriman = '' OR d.status_pengiriman IN ('Menunggu', 'Siap Dikirim'))
    ORDER BY d.status_pengiriman ASC, d.tanggal_buat DESC
";

$result = mysqli_query($koneksi, $query);

$data = [];
while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode(["status" => "success", "data" => $data]);
?>