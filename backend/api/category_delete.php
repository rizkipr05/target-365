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
$categoryId = int_value($payload['id'] ?? 0, 0);

if ($categoryId <= 0) {
    json_response([
        'success' => false,
        'message' => 'ID kategori wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$existing = fetch_one(
    'SELECT id FROM target_categories WHERE id = :id AND user_id = :userId LIMIT 1',
    ['id' => $categoryId, 'userId' => $userId]
);

if ($existing === null) {
    json_response([
        'success' => false,
        'message' => 'Kategori tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$stmt = db()->prepare('DELETE FROM target_categories WHERE id = :id AND user_id = :userId');
$stmt->execute([
    'id' => $categoryId,
    'userId' => $userId,
]);

json_response([
    'success' => true,
    'message' => 'Kategori berhasil dihapus',
    'data' => new stdClass(),
]);
