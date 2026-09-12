<?php
error_reporting(0); // Mencegah output warning/notice yang merusak JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

header("Content-Type: application/json; charset=UTF-8");
require '../../config/database.php';
require '../config/helpers_notif.php';

try {
    $data = json_decode(file_get_contents("php://input"));

    if (!$data) {
        throw new Exception("Format data tidak valid");
    }

    if (
        isset($data->jenis_dokumen) && isset($data->nomor_dokumen) && 
        isset($data->id_supir) && isset($data->id_barang) &&
        isset($data->id_admin) && isset($data->tujuan) && isset($data->jumlah)
    ) {
        // PREPARED STATEMENT UNTUK TABEL DOKUMEN
        $stmt_dok = $koneksi->prepare("INSERT INTO dokumen (nomor_dokumen, jenis_dokumen, id_admin, id_supir, tujuan_pengiriman) VALUES (?, ?, ?, ?, ?)");
        if (!$stmt_dok) {
            throw new Exception("Gagal menyiapkan statement dokumen: " . $koneksi->error);
        }
        $stmt_dok->bind_param("ssiis", $data->nomor_dokumen, $data->jenis_dokumen, $data->id_admin, $data->id_supir, $data->tujuan);
        
        if ($stmt_dok->execute()) {
            $id_dokumen_baru = $koneksi->insert_id;
            $stmt_dok->close();
            
            // PREPARED STATEMENT UNTUK TABEL DETAIL DOKUMEN
            $stmt_detail = $koneksi->prepare("INSERT INTO detail_dokumen (id_dokumen, id_barang, jumlah_packing) VALUES (?, ?, ?)");
            if (!$stmt_detail) {
                throw new Exception("Gagal menyiapkan statement detail: " . $koneksi->error);
            }
            $jumlah = (int)$data->jumlah;
            $stmt_detail->bind_param("iii", $id_dokumen_baru, $data->id_barang, $jumlah);
            $stmt_detail->execute();
            $stmt_detail->close();

            // Notifikasi ke Gudang dan Supir
            buat_notifikasi_role($koneksi, 'karyawan_gudang', 'Tugas Packing Baru', "Dokumen $data->nomor_dokumen siap untuk dipacking.");
            buat_notifikasi_user($koneksi, $data->id_supir, 'Tugas Pengiriman Baru', "Anda ditugaskan untuk mengirimkan dokumen $data->nomor_dokumen.");

            echo json_encode(["status" => "success", "message" => "Dokumen berhasil dibuat!"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal membuat dokumen: " . $stmt_dok->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Data form tidak lengkap!"]);
    }
} catch (mysqli_sql_exception $e) {
    if (strpos($e->getMessage(), 'Duplicate entry') !== false) {
        echo json_encode(["status" => "error", "message" => "Nomor Resi / Surat Jalan ini sudah pernah digunakan!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Terjadi kesalahan database: " . $e->getMessage()]);
    }
} catch (Throwable $e) {
    echo json_encode(["status" => "error", "message" => "Terjadi kesalahan sistem: " . $e->getMessage() . " on line " . $e->getLine() . " in " . $e->getFile()]);
}
?>
