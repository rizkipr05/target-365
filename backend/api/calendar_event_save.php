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
$eventId = int_value($payload['id'] ?? 0, 0);
$day = int_value($payload['day'] ?? 0, 0);
$title = trim((string) ($payload['title'] ?? ''));
$color = trim((string) ($payload['color'] ?? ''));
$time = trim((string) ($payload['time'] ?? ''));
$type = trim((string) ($payload['type'] ?? 'Target'));

if ($day < 1 || $day > 31 || $title === '') {
    json_response([
        'success' => false,
        'message' => 'Hari dan judul kegiatan wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

$defaults = [
    'color' => '#22C55E',
    'type' => $type !== '' ? $type : 'Target',
];

switch (strtolower($type)) {
    case 'motivasi':
        $defaults['color'] = '#F59E0B';
        break;
    case 'kebiasaan':
        $defaults['color'] = '#8B5CF6';
        break;
    case 'deadline':
        $defaults['color'] = '#EF4444';
        break;
    case 'aktivitas':
        $defaults['color'] = '#22C55E';
        break;
}

$color = $color !== '' ? $color : $defaults['color'];
$type = $type !== '' ? $type : $defaults['type'];

if ($eventId > 0) {
    $existing = fetch_one(
        'SELECT id FROM calendar_events WHERE id = :id AND user_id = :userId LIMIT 1',
        ['id' => $eventId, 'userId' => $userId]
    );

    if ($existing === null) {
        json_response([
            'success' => false,
            'message' => 'Kegiatan tidak ditemukan',
            'data' => new stdClass(),
        ], 404);
    }

    $stmt = db()->prepare(
        'UPDATE calendar_events
         SET day = :day, title = :title, color = :color, time_label = :timeLabel, event_type = :eventType
         WHERE id = :id AND user_id = :userId'
    );
    $stmt->execute([
        'day' => $day,
        'title' => $title,
        'color' => $color,
        'timeLabel' => $time,
        'eventType' => $type,
        'id' => $eventId,
        'userId' => $userId,
    ]);
} else {
    $sortOrder = int_value(fetch_one(
        'SELECT COALESCE(MAX(sort_order), 0) AS value FROM calendar_events WHERE user_id = :userId AND day = :day',
        ['userId' => $userId, 'day' => $day]
    )['value'] ?? 0) + 1;

    $stmt = db()->prepare(
        'INSERT INTO calendar_events (user_id, day, title, color, time_label, event_type, sort_order)
         VALUES (:userId, :day, :title, :color, :timeLabel, :eventType, :sortOrder)'
    );
    $stmt->execute([
        'userId' => $userId,
        'day' => $day,
        'title' => $title,
        'color' => $color,
        'timeLabel' => $time,
        'eventType' => $type,
        'sortOrder' => $sortOrder,
    ]);
    $eventId = (int) db()->lastInsertId();
}

$event = fetch_one(
    'SELECT id, day, title, color, time_label AS time, event_type AS type
     FROM calendar_events
     WHERE id = :id AND user_id = :userId
     LIMIT 1',
    ['id' => $eventId, 'userId' => $userId]
);

json_response([
    'success' => true,
    'message' => 'Kegiatan kalender berhasil disimpan',
    'data' => $event ?? new stdClass(),
]);
