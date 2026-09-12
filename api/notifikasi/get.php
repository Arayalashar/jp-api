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

$id_user = isset($_GET['id_user']) ? $_GET['id_user'] : null;

if($id_user) {
    $stmt = $koneksi->prepare("SELECT * FROM notifikasi WHERE id_user = ? ORDER BY created_at DESC");
    $stmt->bind_param("i", $id_user);
    $stmt->execute();
    $result = $stmt->get_result();

    $notifikasi = [];
    while ($row = $result->fetch_assoc()) {
        $notifikasi[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "data" => $notifikasi
    ]);
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "id_user tidak diberikan"]);
}
?>
