<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

require '../../config/database.php';

$role = $_GET['role'] ?? '';
$id_user = $_GET['id_user'] ?? '';

$stats = [];

if ($role === 'admin') {
    // Total dokumen
    $q = mysqli_query($koneksi, "SELECT COUNT(*) as total FROM dokumen");
    $total = mysqli_fetch_assoc($q)['total'];

    $q = mysqli_query($koneksi, "SELECT COUNT(*) as c FROM dokumen WHERE status_pengiriman = 'Sampai Tujuan'");
    $selesai = mysqli_fetch_assoc($q)['c'];

    $q = mysqli_query($koneksi, "SELECT COUNT(*) as c FROM dokumen WHERE status_pengiriman = 'Menunggu'");
    $pending = mysqli_fetch_assoc($q)['c'];

    $q = mysqli_query($koneksi, "SELECT COUNT(*) as c FROM dokumen WHERE status_pengiriman = 'Gagal Kirim'");
    $gagal = mysqli_fetch_assoc($q)['c'];

    $q = mysqli_query($koneksi, "SELECT COUNT(*) as c FROM dokumen WHERE status_pengiriman = 'Dalam Perjalanan'");
    $jalan = mysqli_fetch_assoc($q)['c'];

    $stats = [
        'total' => (int)$total,
        'selesai' => (int)$selesai,
        'pending' => (int)$pending,
        'gagal' => (int)$gagal,
        'dalam_perjalanan' => (int)$jalan,
    ];

} elseif ($role === 'karyawan_gudang') {
    $q = mysqli_query($koneksi, "
        SELECT COUNT(*) as c FROM dokumen 
        WHERE status_pengiriman = 'Menunggu' 
        AND (jenis_dokumen LIKE 'Resi Pengi%' OR jenis_dokumen = 'Surat Jalan')
    ");
    $pending = mysqli_fetch_assoc($q)['c'];

    $q = mysqli_query($koneksi, "
        SELECT COUNT(*) as c FROM sortir_log 
        WHERE DATE(waktu_selesai) = CURDATE()
    ");
    $hari_ini = mysqli_fetch_assoc($q)['c'];

    $q = mysqli_query($koneksi, "SELECT COUNT(*) as c FROM sortir_log");
    $total = mysqli_fetch_assoc($q)['c'];

    $stats = [
        'pending' => (int)$pending,
        'selesai_hari_ini' => (int)$hari_ini,
        'total_packing' => (int)$total,
    ];

} elseif ($role === 'supir') {
    $stmt = $koneksi->prepare("
        SELECT COUNT(*) as c FROM dokumen 
        WHERE id_supir = ? AND status_pengiriman IN ('Siap Dikirim', 'Dalam Perjalanan')
    ");
    $stmt->bind_param("i", $id_user);
    $stmt->execute();
    $aktif = $stmt->get_result()->fetch_assoc()['c'];
    $stmt->close();

    $stmt = $koneksi->prepare("
        SELECT COUNT(*) as c FROM dokumen 
        WHERE id_supir = ? AND status_pengiriman = 'Sampai Tujuan'
    ");
    $stmt->bind_param("i", $id_user);
    $stmt->execute();
    $selesai = $stmt->get_result()->fetch_assoc()['c'];
    $stmt->close();

    $stmt = $koneksi->prepare("SELECT COUNT(*) as c FROM dokumen WHERE id_supir = ?");
    $stmt->bind_param("i", $id_user);
    $stmt->execute();
    $total = $stmt->get_result()->fetch_assoc()['c'];
    $stmt->close();

    $stats = [
        'aktif' => (int)$aktif,
        'selesai' => (int)$selesai,
        'total' => (int)$total,
    ];

} elseif ($role === 'supervisor') {
    $q = mysqli_query($koneksi, "
        SELECT COUNT(*) as c FROM dokumen 
        WHERE status_pengiriman = 'Sampai Tujuan'
        AND id_dokumen NOT IN (
            SELECT DISTINCT dd.id_dokumen FROM detail_dokumen dd
            INNER JOIN pemeriksaan p ON dd.id_barang = p.id_barang
        )
    ");
    $pending = mysqli_fetch_assoc($q)['c'];

    $q = mysqli_query($koneksi, "SELECT COUNT(*) as c FROM pemeriksaan");
    $total = mysqli_fetch_assoc($q)['c'];

    $q = mysqli_query($koneksi, "
        SELECT COUNT(*) as c FROM pemeriksaan 
        WHERE DATE(tanggal_pemeriksaan) = CURDATE()
    ");
    $hari_ini = mysqli_fetch_assoc($q)['c'];

    $stats = [
        'pending' => (int)$pending,
        'total_periksa' => (int)$total,
        'hari_ini' => (int)$hari_ini,
    ];
}

echo json_encode([
    "status" => "success",
    "data" => $stats
]);

mysqli_close($koneksi);
?>
