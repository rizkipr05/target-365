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

$existing = fetch_one('SELECT * FROM users WHERE id = :id LIMIT 1', ['id' => $userId]);
if ($existing === null) {
    json_response([
        'success' => false,
        'message' => 'User tidak ditemukan',
        'data' => new stdClass(),
    ], 404);
}

$fields = [
    'name' => $payload['name'] ?? $existing['name'],
    'username' => $payload['username'] ?? $existing['username'],
    'email' => $payload['email'] ?? $existing['email'],
    'tagline' => $payload['tagline'] ?? $existing['tagline'],
    'about' => $payload['about'] ?? $existing['about'],
    'phone' => $payload['phone'] ?? $existing['phone'],
    'location' => $payload['location'] ?? $existing['location'],
    'language' => $payload['language'] ?? $existing['language'],
    'dateFormat' => $payload['dateFormat'] ?? $existing['date_format'],
];

$settings = [
    'darkMode' => bool_value($payload['darkMode'] ?? $existing['dark_mode']),
    'compactView' => bool_value($payload['compactView'] ?? $existing['compact_view']),
    'twoFactor' => bool_value($payload['twoFactor'] ?? $existing['two_factor']),
    'notifPush' => bool_value($payload['notifPush'] ?? $existing['notif_push']),
    'notifEmail' => bool_value($payload['notifEmail'] ?? $existing['notif_email']),
    'notifTargetReminder' => bool_value($payload['notifTargetReminder'] ?? $existing['notif_target_reminder']),
    'notifAchievement' => bool_value($payload['notifAchievement'] ?? $existing['notif_achievement']),
    'notifWeekly' => bool_value($payload['notifWeekly'] ?? $existing['notif_weekly']),
    'notifMotivasi' => bool_value($payload['notifMotivasi'] ?? $existing['notif_motivasi']),
];

$stmt = db()->prepare(
    'UPDATE users SET
        name = :name,
        username = :username,
        email = :email,
        tagline = :tagline,
        about = :about,
        phone = :phone,
        location = :location,
        language = :language,
        date_format = :dateFormat,
        dark_mode = :darkMode,
        compact_view = :compactView,
        two_factor = :twoFactor,
        notif_push = :notifPush,
        notif_email = :notifEmail,
        notif_target_reminder = :notifTargetReminder,
        notif_achievement = :notifAchievement,
        notif_weekly = :notifWeekly,
        notif_motivasi = :notifMotivasi
     WHERE id = :id'
);

$stmt->execute([
    'id' => $userId,
    'name' => $fields['name'],
    'username' => $fields['username'],
    'email' => $fields['email'],
    'tagline' => $fields['tagline'],
    'about' => $fields['about'],
    'phone' => $fields['phone'],
    'location' => $fields['location'],
    'language' => $fields['language'],
    'dateFormat' => $fields['dateFormat'],
    'darkMode' => $settings['darkMode'] ? 1 : 0,
    'compactView' => $settings['compactView'] ? 1 : 0,
    'twoFactor' => $settings['twoFactor'] ? 1 : 0,
    'notifPush' => $settings['notifPush'] ? 1 : 0,
    'notifEmail' => $settings['notifEmail'] ? 1 : 0,
    'notifTargetReminder' => $settings['notifTargetReminder'] ? 1 : 0,
    'notifAchievement' => $settings['notifAchievement'] ? 1 : 0,
    'notifWeekly' => $settings['notifWeekly'] ? 1 : 0,
    'notifMotivasi' => $settings['notifMotivasi'] ? 1 : 0,
]);

$updated = fetch_one('SELECT * FROM users WHERE id = :id LIMIT 1', ['id' => $userId]);

json_response([
    'success' => true,
    'message' => 'Profil berhasil diperbarui',
    'data' => [
        'name' => $updated['name'],
        'username' => $updated['username'],
        'email' => $updated['email'],
        'role' => $updated['role'],
        'joinDate' => $updated['join_date'],
        'tagline' => $updated['tagline'],
        'about' => $updated['about'],
        'birthday' => $updated['birthday'],
        'gender' => $updated['gender'],
        'phone' => $updated['phone'],
        'location' => $updated['location'],
        'avatarUrl' => $updated['avatar_url'],
        'language' => $updated['language'],
        'dateFormat' => $updated['date_format'],
        'darkMode' => bool_value($updated['dark_mode']),
        'compactView' => bool_value($updated['compact_view']),
        'twoFactor' => bool_value($updated['two_factor']),
        'notifPush' => bool_value($updated['notif_push']),
        'notifEmail' => bool_value($updated['notif_email']),
        'notifTargetReminder' => bool_value($updated['notif_target_reminder']),
        'notifAchievement' => bool_value($updated['notif_achievement']),
        'notifWeekly' => bool_value($updated['notif_weekly']),
        'notifMotivasi' => bool_value($updated['notif_motivasi']),
        'reminderTime' => $updated['reminder_time'],
        'dndStart' => $updated['dnd_start'],
        'dndEnd' => $updated['dnd_end'],
        'summary' => [
            'totalTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId', ['userId' => $userId])['value'] ?? 0),
            'completedTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId AND status = \'Selesai\'', ['userId' => $userId])['value'] ?? 0),
            'inProgressTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId AND status = \'Sedang Berjalan\'', ['userId' => $userId])['value'] ?? 0),
            'notStartedTargets' => int_value(fetch_one('SELECT COUNT(*) AS value FROM targets WHERE user_id = :userId AND status = \'Belum Dimulai\'', ['userId' => $userId])['value'] ?? 0),
            'averageCompletion' => float_value(fetch_one('SELECT COALESCE(AVG(progress), 0) AS value FROM targets WHERE user_id = :userId', ['userId' => $userId])['value'] ?? 0) * 100,
        ],
    ],
]);
