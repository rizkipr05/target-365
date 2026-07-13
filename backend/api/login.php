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
$identity = trim((string) ($payload['email'] ?? $payload['username'] ?? ''));
$password = (string) ($payload['password'] ?? '');

if ($identity === '' || $password === '') {
    json_response([
        'success' => false,
        'message' => 'Email/username dan password wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$user = fetch_one(
    'SELECT id, name, username, email, password, role, avatar_url
     FROM users
     WHERE email = :identity_email OR username = :identity_username
     LIMIT 1',
    [
        'identity_email' => $identity,
        'identity_username' => $identity,
    ]
);

if ($user === null) {
    json_response([
        'success' => false,
        'message' => 'Akun tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$storedPassword = (string) $user['password'];
$validPassword = password_verify($password, $storedPassword) || hash_equals($storedPassword, $password);

if (!$validPassword) {
    json_response([
        'success' => false,
        'message' => 'Password salah',
        'data' => new stdClass(),
    ], 401);
}

$token = bin2hex(random_bytes(32));

json_response([
    'success' => true,
    'message' => 'Login berhasil',
    'data' => [
        'token' => $token,
        'user' => [
            'id' => int_value($user['id']),
            'name' => $user['name'],
            'username' => $user['username'],
            'email' => $user['email'],
            'role' => $user['role'],
            'avatarUrl' => $user['avatar_url'],
        ],
    ],
]);
