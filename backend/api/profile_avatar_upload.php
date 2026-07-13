<?php

declare(strict_types=1);

require __DIR__ . '/_bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response([
        'success' => false,
        'message' => 'Method not allowed',
        'data' => new stdClass(),
    ], 405);
}

$payload = array_merge($_POST, input_json());
$userId = int_value($payload['userId'] ?? 1, 1);

$user = fetch_one('SELECT id, avatar_url FROM users WHERE id = :id LIMIT 1', ['id' => $userId]);
if ($user === null) {
    json_response([
        'success' => false,
        'message' => 'User tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$avatarUrl = trim((string) ($payload['avatarUrl'] ?? ''));

if (isset($_FILES['avatar']) && is_array($_FILES['avatar']) && ($_FILES['avatar']['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_OK) {
    $upload = $_FILES['avatar'];
    $originalName = (string) ($upload['name'] ?? 'avatar.png');
    $extension = strtolower(pathinfo($originalName, PATHINFO_EXTENSION));
    $allowed = ['jpg', 'jpeg', 'png', 'webp', 'gif'];
    if (!in_array($extension, $allowed, true)) {
        json_response([
            'success' => false,
            'message' => 'Format foto tidak didukung',
            'data' => new stdClass(),
        ], 422);
    }

    $uploadDir = dirname(__DIR__) . '/uploads/avatars';
    if (!is_dir($uploadDir) && !mkdir($uploadDir, 0775, true) && !is_dir($uploadDir)) {
        json_response([
            'success' => false,
            'message' => 'Gagal menyiapkan folder upload',
            'data' => new stdClass(),
        ], 500);
    }

    $filename = sprintf('user_%d_%s.%s', $userId, date('YmdHis'), $extension);
    $destination = $uploadDir . '/' . $filename;
    if (!move_uploaded_file((string) $upload['tmp_name'], $destination)) {
        json_response([
            'success' => false,
            'message' => 'Gagal menyimpan file foto',
            'data' => new stdClass(),
        ], 500);
    }

    $avatarUrl = public_url('uploads/avatars/' . $filename);
} elseif ($avatarUrl === '') {
    json_response([
        'success' => false,
        'message' => 'Avatar URL atau file avatar wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$stmt = db()->prepare('UPDATE users SET avatar_url = :avatarUrl WHERE id = :id');
$stmt->execute([
    'avatarUrl' => $avatarUrl,
    'id' => $userId,
]);

json_response([
    'success' => true,
    'message' => 'Foto profil berhasil diperbarui',
    'data' => [
        'avatarUrl' => $avatarUrl,
    ],
]);
