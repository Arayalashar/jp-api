<?php
function buat_notifikasi_user($koneksi, $id_user, $judul, $pesan) {
    $stmt = $koneksi->prepare("INSERT INTO notifikasi (id_user, judul, pesan) VALUES (?, ?, ?)");
    if($stmt) {
        $stmt->bind_param("iss", $id_user, $judul, $pesan);
        $stmt->execute();
        $stmt->close();
    }
}

function buat_notifikasi_role($koneksi, $role, $judul, $pesan) {
    $stmt = $koneksi->prepare("SELECT id_user FROM users WHERE role = ?");
    if($stmt) {
        $stmt->bind_param("s", $role);
        $stmt->execute();
        $res = $stmt->get_result();
        $users = [];
        while($r = $res->fetch_assoc()){
            $users[] = $r['id_user'];
        }
        $stmt->close();
        
        foreach($users as $id) {
            buat_notifikasi_user($koneksi, $id, $judul, $pesan);
        }
    }
}
?>
