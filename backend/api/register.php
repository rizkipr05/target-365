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
$name = trim((string) ($payload['name'] ?? ''));
$username = trim((string) ($payload['username'] ?? ''));
$email = trim((string) ($payload['email'] ?? ''));
$password = (string) ($payload['password'] ?? '');
$confirmPassword = (string) ($payload['confirmPassword'] ?? '');

if ($name === '' || $username === '' || $email === '' || $password === '' || $confirmPassword === '') {
    json_response([
        'success' => false,
        'message' => 'Semua kolom wajib diisi',
        'data' => new stdClass(),
    ], 422);
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    json_response([
        'success' => false,
        'message' => 'Format email tidak valid',
        'data' => new stdClass(),
    ], 422);
}

if (strlen($username) < 3) {
    json_response([
        'success' => false,
        'message' => 'Username minimal 3 karakter',
        'data' => new stdClass(),
    ], 422);
}

if (strlen($password) < 8) {
    json_response([
        'success' => false,
        'message' => 'Password minimal 8 karakter',
        'data' => new stdClass(),
    ], 422);
}

if ($password !== $confirmPassword) {
    json_response([
        'success' => false,
        'message' => 'Password dan konfirmasi tidak sama',
        'data' => new stdClass(),
    ], 422);
}

$existing = fetch_one(
    'SELECT id FROM users WHERE email = :email OR username = :username LIMIT 1',
    [
        'email' => $email,
        'username' => $username,
    ]
);

if ($existing !== null) {
    json_response([
        'success' => false,
        'message' => 'Email atau username sudah digunakan',
        'data' => new stdClass(),
    ], 409);
}

$avatarUrl = sprintf(
    'https://ui-avatars.com/api/?name=%s&background=22C55E&color=ffffff&size=256',
    rawurlencode($name)
);
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
$joinDate = date('j M Y');

$stmt = db()->prepare(
    'INSERT INTO users (
        name, username, email, password, role, avatar_url, tagline, about, birthday, gender, phone, location,
        language, date_format, dark_mode, compact_view, two_factor,
        notif_push, notif_email, notif_target_reminder, notif_achievement, notif_weekly, notif_motivasi,
        reminder_time, dnd_start, dnd_end, calendar_month_label, calendar_month, calendar_year, calendar_selected_day, notifications_count, join_date
     ) VALUES (
        :name, :username, :email, :password, :role, :avatarUrl, :tagline, :about, :birthday, :gender, :phone, :location,
        :language, :dateFormat, :darkMode, :compactView, :twoFactor,
        :notifPush, :notifEmail, :notifTargetReminder, :notifAchievement, :notifWeekly, :notifMotivasi,
        :reminderTime, :dndStart, :dndEnd, :calendarMonthLabel, :calendarMonth, :calendarYear, :calendarSelectedDay, :notificationsCount, :joinDate
     )'
);

$stmt->execute([
    'name' => $name,
    'username' => $username,
    'email' => $email,
    'password' => $hashedPassword,
    'role' => 'Pengguna',
    'avatarUrl' => $avatarUrl,
    'tagline' => 'Siap mencapai target baru.',
    'about' => 'Saya pengguna baru Target365.',
    'birthday' => '',
    'gender' => '',
    'phone' => '',
    'location' => '',
    'language' => 'Bahasa Indonesia',
    'dateFormat' => 'DD/MM/YYYY',
    'darkMode' => 0,
    'compactView' => 0,
    'twoFactor' => 0,
    'notifPush' => 1,
    'notifEmail' => 0,
    'notifTargetReminder' => 1,
    'notifAchievement' => 1,
    'notifWeekly' => 0,
    'notifMotivasi' => 1,
    'reminderTime' => '07:00',
    'dndStart' => '22:00',
    'dndEnd' => '06:00',
    'calendarMonthLabel' => 'Mei 2025',
    'calendarMonth' => 5,
    'calendarYear' => 2025,
    'calendarSelectedDay' => 1,
    'notificationsCount' => 0,
    'joinDate' => $joinDate,
]);

$userId = (int) db()->lastInsertId();
$token = bin2hex(random_bytes(32));

json_response([
    'success' => true,
    'message' => 'Pendaftaran berhasil',
    'data' => [
        'token' => $token,
        'user' => [
            'id' => $userId,
            'name' => $name,
            'username' => $username,
            'email' => $email,
            'role' => 'Pengguna',
            'avatarUrl' => $avatarUrl,
        ],
    ],
]);
