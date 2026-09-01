<?php
$data = json_encode([
    'jenis_dokumen' => 'Resi Pengiriman',
    'nomor_dokumen' => 'F-02',
    'tujuan' => 'JOgja',
    'id_supir' => '4',
    'id_barang' => '1',
    'jumlah' => '12',
    'id_admin' => '1'
]);
$ch = curl_init('http://localhost/JP/api/dokumen/buat.php');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
$response = curl_exec($ch);
echo 'RESPONSE: ' . $response;
?>
