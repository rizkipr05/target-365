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
$name = trim((string) ($payload['name'] ?? ''));
$description = trim((string) ($payload['description'] ?? ''));

if ($name === '') {
    json_response([
        'success' => false,
        'message' => 'Nama kategori wajib diisi',
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

$sortOrder = int_value(fetch_one('SELECT COALESCE(MAX(sort_order), 0) AS value FROM target_categories WHERE user_id = :userId', ['userId' => $userId])['value'] ?? 0) + 1;
$jumlahTarget = trim((string) ($payload['jumlahTarget'] ?? '0 target'));
$status = trim((string) ($payload['status'] ?? 'Aktif'));

$stmt = db()->prepare(
    'INSERT INTO target_categories (
        user_id, name, description, icon_name, icon_bg, icon_color, jumlah_target, status, sort_order
     ) VALUES (
        :userId, :name, :description, :iconName, :iconBg, :iconColor, :jumlahTarget, :status, :sortOrder
     )'
);

$stmt->execute([
    'userId' => $userId,
    'name' => $name,
    'description' => $description !== '' ? $description : 'Kategori baru untuk target Anda.',
    'iconName' => $template['icon_name'],
    'iconBg' => $template['icon_bg'],
    'iconColor' => $template['icon_color'],
    'jumlahTarget' => $jumlahTarget,
    'status' => $status,
    'sortOrder' => $sortOrder,
]);

json_response([
    'success' => true,
    'message' => 'Kategori berhasil ditambahkan',
    'data' => ['id' => (int) db()->lastInsertId()],
]);

