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

if(isset($data->id_notif)) {
    $stmt = $koneksi->prepare("UPDATE notifikasi SET is_read = 1 WHERE id_notif = ?");
    $stmt->bind_param("i", $data->id_notif);
    
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Notifikasi dibaca"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal update"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "id_notif tidak diberikan"]);
}
?>
