<?php

declare(strict_types=1);

require __DIR__ . '/_bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    json_response([
        'success' => false,
        'message' => 'Method not allowed',
        'data' => new stdClass(),
    ], 405);
}

$userId = int_value($_GET['userId'] ?? 1, 1);
$user = fetch_one('SELECT id, name FROM users WHERE id = :id LIMIT 1', ['id' => $userId]);

if ($user === null) {
    json_response([
        'success' => false,
        'message' => 'User tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$summary = [
    'totalTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId', ['userId' => $userId])['value'] ?? 0),
    'completedTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId AND status = \'Selesai\'', ['userId' => $userId])['value'] ?? 0),
    'inProgressTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId AND status = \'Sedang Berjalan\'', ['userId' => $userId])['value'] ?? 0),
    'notStartedTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId AND status = \'Belum Dimulai\'', ['userId' => $userId])['value'] ?? 0),
    'averageCompletion' => float_value(fetch_one('SELECT COALESCE(AVG(progress), 0) AS value FROM targets WHERE user_id = :userId', ['userId' => $userId])['value'] ?? 0) * 100,
];

$targets = fetch_all(
    'SELECT title, category, priority, deadline, progress_label AS progressLabel, status
     FROM targets
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC',
    ['userId' => $userId]
);

$categoryProgress = fetch_all(
    'SELECT name, percent, target_summary AS targetSummary
     FROM report_category_progress
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC',
    ['userId' => $userId]
);

$trends = fetch_all(
    'SELECT label, value
     FROM report_trends
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC',
    ['userId' => $userId]
);

$escape = static function (string $value): string {
    return '"' . str_replace('"', '""', $value) . '"';
};

$lines = [];
$lines[] = ['Target365 Report'];
$lines[] = ['Nama', (string) $user['name']];
$lines[] = ['Tanggal Ekspor', date('Y-m-d H:i:s')];
$lines[] = [];
$lines[] = ['Ringkasan'];
$lines[] = ['Total Target', (string) $summary['totalTargets']];
$lines[] = ['Target Selesai', (string) $summary['completedTargets']];
$lines[] = ['Sedang Berjalan', (string) $summary['inProgressTargets']];
$lines[] = ['Belum Dimulai', (string) $summary['notStartedTargets']];
$lines[] = ['Rata-rata Penyelesaian', number_format($summary['averageCompletion'], 0) . '%'];
$lines[] = [];
$lines[] = ['Daftar Target'];
$lines[] = ['Judul', 'Kategori', 'Prioritas', 'Deadline', 'Progress', 'Status'];
foreach ($targets as $target) {
    $lines[] = [
        (string) $target['title'],
        (string) $target['category'],
        (string) $target['priority'],
        (string) $target['deadline'],
        (string) $target['progressLabel'],
        (string) $target['status'],
    ];
}
$lines[] = [];
$lines[] = ['Progress per Kategori'];
$lines[] = ['Kategori', 'Persentase', 'Ringkasan'];
foreach ($categoryProgress as $category) {
    $lines[] = [
        (string) $category['name'],
        (string) $category['percent'] . '%',
        (string) $category['targetSummary'],
    ];
}
$lines[] = [];
$lines[] = ['Tren'];
$lines[] = ['Bulan', 'Nilai'];
foreach ($trends as $trend) {
    $lines[] = [
        (string) $trend['label'],
        (string) $trend['value'],
    ];
}

$content = '';
foreach ($lines as $row) {
    if ($row === []) {
        $content .= "\n";
        continue;
    }
    $content .= implode(',', array_map($escape, $row)) . "\n";
}

json_response([
    'success' => true,
    'message' => 'Laporan berhasil diekspor',
    'data' => [
        'filename' => sprintf('target365-report-%s.csv', date('Ymd-His')),
        'content' => $content,
    ],
]);
