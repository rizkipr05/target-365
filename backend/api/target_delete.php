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
$targetId = int_value($payload['id'] ?? 0, 0);

if ($targetId <= 0) {
    json_response([
        'success' => false,
        'message' => 'ID target wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$existing = fetch_one(
    'SELECT id FROM targets WHERE id = :id AND user_id = :userId LIMIT 1',
    ['id' => $targetId, 'userId' => $userId]
);

if ($existing === null) {
    json_response([
        'success' => false,
        'message' => 'Target tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$stmt = db()->prepare('DELETE FROM targets WHERE id = :id AND user_id = :userId');
$stmt->execute([
    'id' => $targetId,
    'userId' => $userId,
]);

json_response([
    'success' => true,
    'message' => 'Target berhasil dihapus',
    'data' => new stdClass(),
]);
