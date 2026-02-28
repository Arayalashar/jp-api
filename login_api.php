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
require 'koneksi.php';

// Menangkap data JSON
$data = json_decode(file_get_contents("php://input"));

if(isset($data->username) && isset($data->password)) {
    $username = mysqli_real_escape_string($koneksi, $data->username);
    $password = $data->password;

    $query = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    $result = mysqli_query($koneksi, $query);

    if (mysqli_num_rows($result) === 1) {
        $row = mysqli_fetch_assoc($result);
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
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>