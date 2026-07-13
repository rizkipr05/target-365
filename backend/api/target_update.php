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
$title = trim((string) ($payload['title'] ?? ''));
$category = trim((string) ($payload['category'] ?? ''));
$priority = trim((string) ($payload['priority'] ?? 'Sedang'));
$deadline = trim((string) ($payload['deadline'] ?? ''));
$status = trim((string) ($payload['status'] ?? 'Belum Dimulai'));
$progressRaw = $payload['progress'] ?? null;
$progress = is_numeric($progressRaw) ? max(0.0, min(1.0, float_value($progressRaw))) : null;

if ($targetId <= 0 || $title === '' || $category === '' || $deadline === '') {
    json_response([
        'success' => false,
        'message' => 'ID, judul, kategori, dan deadline wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$template = [
    'icon_name' => 'track_changes_rounded',
    'icon_bg' => '#DCFCE7',
    'icon_color' => '#22C55E',
    'category_color' => '#22C55E',
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

$statusColor = '#6B7280';
switch (strtolower($status)) {
    case 'selesai':
        $statusColor = '#22C55E';
        if ($progress === null) {
            $progress = 1.0;
        }
        break;
    case 'sedang berjalan':
        $statusColor = '#F59E0B';
        if ($progress === null) {
            $progress = 0.5;
        }
        break;
    default:
        $status = 'Belum Dimulai';
        if ($progress === null) {
            $progress = 0.0;
        }
        break;
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

$progressLabel = sprintf('%d%%', (int) round($progress * 100));

$stmt = db()->prepare(
    'UPDATE targets
     SET title = :title,
         icon_name = :iconName,
         icon_bg = :iconBg,
         icon_color = :iconColor,
         category = :category,
         category_color = :categoryColor,
         priority = :priority,
         deadline = :deadline,
         progress = :progress,
         progress_label = :progressLabel,
         status = :status,
         status_color = :statusColor
     WHERE id = :id AND user_id = :userId'
);

$stmt->execute([
    'title' => $title,
    'iconName' => $template['icon_name'],
    'iconBg' => $template['icon_bg'],
    'iconColor' => $template['icon_color'],
    'category' => $category,
    'categoryColor' => $template['category_color'],
    'priority' => $priority !== '' ? $priority : 'Sedang',
    'deadline' => $deadline,
    'progress' => $progress,
    'progressLabel' => $progressLabel,
    'status' => $status,
    'statusColor' => $statusColor,
    'id' => $targetId,
    'userId' => $userId,
]);

json_response([
    'success' => true,
    'message' => 'Target berhasil diperbarui',
    'data' => [
        'id' => $targetId,
    ],
]);
