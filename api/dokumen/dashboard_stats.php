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

    $riwayat = [];
    $qLog = mysqli_query($koneksi, "
        SELECT sl.*, d.nomor_dokumen, d.tujuan_pengiriman
        FROM sortir_log sl
        JOIN dokumen d ON sl.id_dokumen = d.id_dokumen
        ORDER BY sl.waktu_selesai DESC LIMIT 3
    ");
    if ($qLog) {
        while($r = mysqli_fetch_assoc($qLog)){
            $riwayat[] = [
                'id' => $r['nomor_dokumen'],
                'title' => 'Packing ' . $r['nomor_dokumen'],
                'subtitle' => 'Selesai: ' . $r['waktu_selesai'],
                'status' => 'Selesai'
            ];
        }
    }

    $chart_data = [0,0,0,0,0,0,0];
    $qChart = mysqli_query($koneksi, "
        SELECT WEEKDAY(waktu_selesai) as day_idx, COUNT(*) as c 
        FROM sortir_log 
        WHERE YEARWEEK(waktu_selesai, 1) = YEARWEEK(CURDATE(), 1)
        GROUP BY day_idx
    ");
    if($qChart) {
        while($r = mysqli_fetch_assoc($qChart)){
            $chart_data[$r['day_idx']] = (int)$r['c'];
        }
    }

    $stats = [
        'pending' => (int)$pending,
        'selesai_hari_ini' => (int)$hari_ini,
        'total_packing' => (int)$total,
        'riwayat_terbaru' => $riwayat,
        'chart_data' => $chart_data
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

    $riwayat = [];
    $stmtLog = $koneksi->prepare("
        SELECT nomor_dokumen, tanggal_buat, tujuan_pengiriman, status_pengiriman 
        FROM dokumen 
        WHERE id_supir = ? AND status_pengiriman IN ('Sampai Tujuan', 'Gagal Kirim')
        ORDER BY tanggal_buat DESC LIMIT 3
    ");
    $stmtLog->bind_param("i", $id_user);
    $stmtLog->execute();
    $resLog = $stmtLog->get_result();
    while($r = $resLog->fetch_assoc()){
        $riwayat[] = [
            'id' => $r['nomor_dokumen'],
            'title' => 'Pengiriman ' . $r['nomor_dokumen'],
            'subtitle' => 'Tujuan: ' . $r['tujuan_pengiriman'],
            'status' => $r['status_pengiriman']
        ];
    }
    $stmtLog->close();

    $chart_data = [0,0,0,0,0,0,0];
    $stmtChart = $koneksi->prepare("
        SELECT WEEKDAY(tanggal_buat) as day_idx, COUNT(*) as c 
        FROM dokumen 
        WHERE id_supir = ? AND status_pengiriman = 'Sampai Tujuan'
        AND YEARWEEK(tanggal_buat, 1) = YEARWEEK(CURDATE(), 1)
        GROUP BY day_idx
    ");
    $stmtChart->bind_param("i", $id_user);
    $stmtChart->execute();
    $resChart = $stmtChart->get_result();
    while($r = $resChart->fetch_assoc()){
        $chart_data[$r['day_idx']] = (int)$r['c'];
    }
    $stmtChart->close();

    $stats = [
        'aktif' => (int)$aktif,
        'selesai' => (int)$selesai,
        'total' => (int)$total,
        'riwayat_terbaru' => $riwayat,
        'chart_data' => $chart_data
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

    $riwayat = [];
    $qLog = mysqli_query($koneksi, "
        SELECT p.*, b.nama_barang, b.kode_barang 
        FROM pemeriksaan p
        JOIN barang b ON p.id_barang = b.id_barang
        ORDER BY p.tanggal_pemeriksaan DESC LIMIT 3
    ");
    if ($qLog) {
        while($r = mysqli_fetch_assoc($qLog)){
            $riwayat[] = [
                'id' => $r['kode_barang'],
                'title' => 'QC: ' . $r['nama_barang'],
                'subtitle' => 'Diperiksa: ' . $r['tanggal_pemeriksaan'],
                'status' => $r['status_pemeriksaan']
            ];
        }
    }

    $chart_data = [0,0,0,0,0,0,0];
    $qChart = mysqli_query($koneksi, "
        SELECT WEEKDAY(tanggal_pemeriksaan) as day_idx, COUNT(*) as c 
        FROM pemeriksaan 
        WHERE YEARWEEK(tanggal_pemeriksaan, 1) = YEARWEEK(CURDATE(), 1)
        GROUP BY day_idx
    ");
    if($qChart) {
        while($r = mysqli_fetch_assoc($qChart)){
            $chart_data[$r['day_idx']] = (int)$r['c'];
        }
    }

    $stats = [
        'pending' => (int)$pending,
        'total_periksa' => (int)$total,
        'hari_ini' => (int)$hari_ini,
        'riwayat_terbaru' => $riwayat,
        'chart_data' => $chart_data
    ];
}

echo json_encode([
    "status" => "success",
    "data" => $stats
]);

mysqli_close($koneksi);
?>
