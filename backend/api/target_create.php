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
$title = trim((string) ($payload['title'] ?? ''));
$category = trim((string) ($payload['category'] ?? ''));
$priority = trim((string) ($payload['priority'] ?? 'Sedang'));
$deadline = trim((string) ($payload['deadline'] ?? ''));

if ($title === '' || $category === '' || $deadline === '') {
    json_response([
        'success' => false,
        'message' => 'Judul, kategori, dan deadline wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$template = [
    'icon_name' => 'track_changes_rounded',
    'icon_bg' => '#DCFCE7',
    'icon_color' => '#22C55E',
    'category_color' => '#22C55E',
    'status_color' => '#F59E0B',
];

switch (strtolower($category)) {
    case 'kesehatan':
        $template['icon_name'] = 'fitness_center_rounded';
        $template['icon_bg'] = '#EFF6FF';
        $template['icon_color'] = '#3B82F6';
        $template['category_color'] = '#3B82F6';
        break;
    case 'keuangan':
        $template['icon_name'] = 'savings_rounded';
        $template['icon_bg'] = '#FFFBEB';
        $template['icon_color'] = '#F59E0B';
        $template['category_color'] = '#F59E0B';
        break;
    case 'karier':
        $template['icon_name'] = 'laptop_rounded';
        $template['icon_bg'] = '#F5F3FF';
        $template['icon_color'] = '#8B5CF6';
        $template['category_color'] = '#8B5CF6';
        break;
    case 'hubungan':
        $template['icon_name'] = 'people_rounded';
        $template['icon_bg'] = '#FFEDF5';
        $template['icon_color'] = '#EC4899';
        $template['category_color'] = '#EC4899';
        break;
}

$sortOrder = int_value(fetch_one('SELECT COALESCE(MAX(sort_order), 0) AS value FROM targets WHERE user_id = :userId', ['userId' => $userId])['value'] ?? 0) + 1;

$stmt = db()->prepare(
    'INSERT INTO targets (
        user_id, title, icon_name, icon_bg, icon_color, category, category_color,
        priority, deadline, progress, progress_label, status, status_color, sort_order
     ) VALUES (
        :userId, :title, :iconName, :iconBg, :iconColor, :category, :categoryColor,
        :priority, :deadline, :progress, :progressLabel, :status, :statusColor, :sortOrder
     )'
);

$stmt->execute([
    'userId' => $userId,
    'title' => $title,
    'iconName' => $template['icon_name'],
    'iconBg' => $template['icon_bg'],
    'iconColor' => $template['icon_color'],
    'category' => $category,
    'categoryColor' => $template['category_color'],
    'priority' => $priority,
    'deadline' => $deadline,
    'progress' => 0,
    'progressLabel' => '0%',
    'status' => 'Belum Dimulai',
    'statusColor' => $template['status_color'],
    'sortOrder' => $sortOrder,
]);

json_response([
    'success' => true,
    'message' => 'Target berhasil ditambahkan',
    'data' => ['id' => (int) db()->lastInsertId()],
]);

