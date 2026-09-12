<?php
// 1. PENGATURAN CORS (Sangat Penting untuk Flutter Web)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// 2. TANGANI SINYAL TES (PREFLIGHT) DARI BROWSER
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

// 3. SETELAH AMAN, LANJUTKAN PROSES LOGIN
header("Content-Type: application/json; charset=UTF-8");
require '../../config/database.php';

// Menangkap data JSON
$data = json_decode(file_get_contents("php://input"));

if(isset($data->username) && isset($data->password)) {
    // FIX BUG: Menggunakan Prepared Statements untuk mencegah SQL Injection
    $stmt = $koneksi->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
    $stmt->bind_param("ss", $data->username, $data->password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 1) {
        $row = $result->fetch_assoc();
        echo json_encode([
            "status" => "success",
            "message" => "Login berhasil",
            "data" => [
                "id_user" => $row['id_user'],
                "nama_lengkap" => $row['nama_lengkap'],
                "role" => $row['role']
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Username atau password salah"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>
