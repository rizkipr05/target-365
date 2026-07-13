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
$quote = trim((string) ($payload['quote'] ?? ''));
$category = trim((string) ($payload['category'] ?? 'Inspirasi'));

if ($quote === '') {
    json_response([
        'success' => false,
        'message' => 'Kutipan motivasi wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$templateColor = '#3B82F6';
switch (strtolower($category)) {
    case 'produktifitas':
    case 'produktivitas':
        $templateColor = '#8B5CF6';
        break;
    case 'mindset':
        $templateColor = '#EC4899';
        break;
    case 'kehidupan':
        $templateColor = '#F59E0B';
        break;
    case 'kebiasaan':
        $templateColor = '#22C55E';
        break;
}

$dateLabel = date('d M Y');
$sortOrder = int_value(fetch_one('SELECT COALESCE(MAX(sort_order), 0) AS value FROM dashboard_quotes WHERE user_id = :userId', ['userId' => $userId])['value'] ?? 0) + 1;

$stmt = db()->prepare(
    'INSERT INTO dashboard_quotes (
        user_id, category, category_color, quote, date_label, liked, sort_order
     ) VALUES (
        :userId, :category, :categoryColor, :quote, :dateLabel, 0, :sortOrder
     )'
);

$stmt->execute([
    'userId' => $userId,
    'category' => $category,
    'categoryColor' => $templateColor,
    'quote' => $quote,
    'dateLabel' => $dateLabel,
    'sortOrder' => $sortOrder,
]);

json_response([
    'success' => true,
    'message' => 'Motivasi berhasil dikirim',
    'data' => ['id' => (int) db()->lastInsertId()],
]);

