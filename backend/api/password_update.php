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
$currentPassword = (string) ($payload['currentPassword'] ?? '');
$newPassword = (string) ($payload['newPassword'] ?? '');
$confirmPassword = (string) ($payload['confirmPassword'] ?? '');

if ($currentPassword === '' || $newPassword === '' || $confirmPassword === '') {
    json_response([
        'success' => false,
        'message' => 'Semua kolom password wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

if ($newPassword !== $confirmPassword) {
    json_response([
        'success' => false,
        'message' => 'Password baru dan konfirmasi tidak sama',
        'data' => new stdClass(),
    ], 422);
}

if (strlen($newPassword) < 8) {
    json_response([
        'success' => false,
        'message' => 'Password baru minimal 8 karakter',
        'data' => new stdClass(),
    ], 422);
}

$user = fetch_one('SELECT id, password FROM users WHERE id = :id LIMIT 1', ['id' => $userId]);
if ($user === null) {
    json_response([
        'success' => false,
        'message' => 'User tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$storedPassword = (string) $user['password'];
$isValid = password_verify($currentPassword, $storedPassword) || hash_equals($storedPassword, $currentPassword);
if (!$isValid) {
    json_response([
        'success' => false,
        'message' => 'Password saat ini salah',
        'data' => new stdClass(),
    ], 401);
}

$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
$stmt = db()->prepare('UPDATE users SET password = :password WHERE id = :id');
$stmt->execute([
    'password' => $hashedPassword,
    'id' => $userId,
]);

json_response([
    'success' => true,
    'message' => 'Password berhasil diperbarui',
    'data' => new stdClass(),
]);
