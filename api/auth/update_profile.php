<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

header("Content-Type: application/json; charset=UTF-8");
require '../../config/database.php';

$data = json_decode(file_get_contents("php://input"));

if(isset($data->id_user)) {
    $id_user = $data->id_user;
    $nama_lengkap = isset($data->nama_lengkap) ? $data->nama_lengkap : null;
    $password = isset($data->password) && !empty($data->password) ? $data->password : null;

    if ($nama_lengkap && $password) {
        $stmt = $koneksi->prepare("UPDATE users SET nama_lengkap = ?, password = ? WHERE id_user = ?");
        $stmt->bind_param("ssi", $nama_lengkap, $password, $id_user);
    } else if ($nama_lengkap) {
        $stmt = $koneksi->prepare("UPDATE users SET nama_lengkap = ? WHERE id_user = ?");
        $stmt->bind_param("si", $nama_lengkap, $id_user);
    } else if ($password) {
        $stmt = $koneksi->prepare("UPDATE users SET password = ? WHERE id_user = ?");
        $stmt->bind_param("si", $password, $id_user);
    } else {
        echo json_encode(["status" => "error", "message" => "Tidak ada data yang diupdate"]);
        exit();
    }
    
    if ($stmt->execute()) {
        // Ambil data terbaru untuk response
        $stmt2 = $koneksi->prepare("SELECT id_user, nama_lengkap, role FROM users WHERE id_user = ?");
        $stmt2->bind_param("i", $id_user);
        $stmt2->execute();
        $res = $stmt2->get_result();
        $user = $res->fetch_assoc();
        $stmt2->close();
        
        echo json_encode([
            "status" => "success", 
            "message" => "Profil berhasil diupdate",
            "data" => $user
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal update profil"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "id_user tidak diberikan"]);
}
?>
