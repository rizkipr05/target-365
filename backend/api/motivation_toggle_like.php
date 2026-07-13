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
$quoteId = int_value($payload['quoteId'] ?? 0, 0);
$liked = bool_value($payload['liked'] ?? false);

if ($quoteId <= 0) {
    json_response([
        'success' => false,
        'message' => 'Quote ID wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$quote = fetch_one(
    'SELECT id, user_id, category, category_color, quote, date_label, liked
     FROM dashboard_quotes
     WHERE id = :id AND user_id = :userId
     LIMIT 1',
    [
        'id' => $quoteId,
        'userId' => $userId,
    ]
);

if ($quote === null) {
    json_response([
        'success' => false,
        'message' => 'Motivasi tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$stmt = db()->prepare('UPDATE dashboard_quotes SET liked = :liked WHERE id = :id AND user_id = :userId');
$stmt->execute([
    'liked' => $liked ? 1 : 0,
    'id' => $quoteId,
    'userId' => $userId,
]);

json_response([
    'success' => true,
    'message' => $liked ? 'Motivasi disimpan ke arsip' : 'Motivasi dihapus dari arsip',
    'data' => [
        'id' => $quoteId,
        'liked' => $liked,
    ],
]);
