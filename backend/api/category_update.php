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
$name = trim((string) ($payload['name'] ?? ''));
$description = trim((string) ($payload['description'] ?? ''));
$jumlahTarget = trim((string) ($payload['jumlahTarget'] ?? '0 target'));
$status = trim((string) ($payload['status'] ?? 'Aktif'));

if ($categoryId <= 0 || $name === '') {
    json_response([
        'success' => false,
        'message' => 'ID dan nama kategori wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$template = [
    'icon_name' => 'eco_rounded',
    'icon_bg' => '#DCFCE7',
    'icon_color' => '#22C55E',
];

switch (strtolower($name)) {
    case 'kesehatan':
        $template['icon_name'] = 'favorite_rounded';
        $template['icon_bg'] = '#FFF1F2';
        $template['icon_color'] = '#EF4444';
        break;
    case 'keuangan':
        $template['icon_name'] = 'account_balance_wallet_rounded';
        $template['icon_bg'] = '#FFFBEB';
        $template['icon_color'] = '#F59E0B';
        break;
    case 'karier':
        $template['icon_name'] = 'work_rounded';
        $template['icon_bg'] = '#F5F3FF';
        $template['icon_color'] = '#8B5CF6';
        break;
    case 'hubungan':
        $template['icon_name'] = 'people_rounded';
        $template['icon_bg'] = '#FFEDF5';
        $template['icon_color'] = '#EC4899';
        break;
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

$stmt = db()->prepare(
    'UPDATE target_categories
     SET name = :name,
         description = :description,
         icon_name = :iconName,
         icon_bg = :iconBg,
         icon_color = :iconColor,
         jumlah_target = :jumlahTarget,
         status = :status
     WHERE id = :id AND user_id = :userId'
);

$stmt->execute([
    'name' => $name,
    'description' => $description !== '' ? $description : 'Kategori yang dikelola pengguna.',
    'iconName' => $template['icon_name'],
    'iconBg' => $template['icon_bg'],
    'iconColor' => $template['icon_color'],
    'jumlahTarget' => $jumlahTarget !== '' ? $jumlahTarget : '0 target',
    'status' => $status !== '' ? $status : 'Aktif',
    'id' => $categoryId,
    'userId' => $userId,
]);

json_response([
    'success' => true,
    'message' => 'Kategori berhasil diperbarui',
    'data' => [
        'id' => $categoryId,
    ],
]);
