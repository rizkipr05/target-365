<?php

declare(strict_types=1);

require __DIR__ . '/_bootstrap.php';

$userId = int_value($_GET['userId'] ?? 1, 1);

$user = fetch_one(
    'SELECT *
     FROM users
     WHERE id = :id
     LIMIT 1',
    ['id' => $userId]
);

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

$dashboardMotivation = fetch_one(
    'SELECT title, quote, author
     FROM dashboard_motivations
     WHERE user_id = :userId
     ORDER BY is_today DESC, sort_order ASC
     LIMIT 1',
    ['userId' => $userId]
) ?: [
    'title' => 'Motivasi Hari Ini',
    'quote' => 'Disiplin hari ini adalah keberhasilan masa depanmu.',
    'author' => 'Target365',
];

$todayTargets = fetch_all(
    'SELECT id, icon_name AS icon, icon_bg AS iconBg, icon_color AS iconColor, title, category, category_color AS categoryColor, priority, deadline, progress, progress_label AS progressLabel, status, status_color AS statusColor
     FROM targets
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC
     LIMIT 3',
    ['userId' => $userId]
);

$categories = fetch_all(
    'SELECT id, icon_name AS icon, icon_bg AS iconBg, icon_color AS iconColor, name, description, jumlah_target AS jumlahTarget, status
     FROM target_categories
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC',
    ['userId' => $userId]
);

$quotes = fetch_all(
    'SELECT id, category, category_color AS categoryColor, quote AS text, date_label AS date, liked
     FROM dashboard_quotes
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC',
    ['userId' => $userId]
);

$reportTargets = fetch_all(
    'SELECT id, icon_name AS icon, icon_color AS iconColor, title, category, category_color AS categoryColor, priority, deadline, progress, status, status_color AS statusColor
     FROM targets
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC
     LIMIT 5',
    ['userId' => $userId]
);

$reportCategoryProgress = fetch_all(
    'SELECT name, color, percent, target_summary AS targetSummary
     FROM report_category_progress
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC',
    ['userId' => $userId]
);

$reportTrends = fetch_all(
    'SELECT label, value
     FROM report_trends
     WHERE user_id = :userId
     ORDER BY sort_order ASC, id ASC',
    ['userId' => $userId]
);

$calendarEntries = fetch_all(
    'SELECT id, day, title, color, time_label AS time, event_type AS type
     FROM calendar_events
     WHERE user_id = :userId
     ORDER BY day ASC, sort_order ASC, id ASC',
    ['userId' => $userId]
);

$deadlines = fetch_all(
    'SELECT color, title, date_label AS date, remaining
     FROM deadlines
     WHERE user_id = :userId
     ORDER BY due_date ASC, id ASC',
    ['userId' => $userId]
);

$profileActivities = fetch_all(
    'SELECT icon_name AS icon, color, background_color AS backgroundColor, title, description, time_label AS time
     FROM profile_activities
     WHERE user_id = :userId
     ORDER BY created_at DESC, id DESC',
    ['userId' => $userId]
);

$achievements = fetch_all(
    'SELECT icon_name AS icon, color, background_color AS backgroundColor, title, subtitle, date_label AS date
     FROM profile_achievements
     WHERE user_id = :userId
     ORDER BY achieved_at DESC, id DESC',
    ['userId' => $userId]
);

$sessions = fetch_all(
    'SELECT icon_name AS icon, title, location, current_device AS currentDevice
     FROM profile_sessions
     WHERE user_id = :userId
     ORDER BY current_device DESC, last_active DESC, id DESC',
    ['userId' => $userId]
);

$profile = [
    'name' => $user['name'],
    'username' => $user['username'],
    'email' => $user['email'],
    'role' => $user['role'],
    'joinDate' => $user['join_date'],
    'tagline' => $user['tagline'],
    'about' => $user['about'],
    'birthday' => $user['birthday'],
    'gender' => $user['gender'],
    'phone' => $user['phone'],
    'location' => $user['location'],
    'avatarUrl' => $user['avatar_url'],
    'language' => $user['language'],
    'dateFormat' => $user['date_format'],
    'darkMode' => bool_value($user['dark_mode']),
    'compactView' => bool_value($user['compact_view']),
    'twoFactor' => bool_value($user['two_factor']),
    'notifPush' => bool_value($user['notif_push']),
    'notifEmail' => bool_value($user['notif_email']),
    'notifTargetReminder' => bool_value($user['notif_target_reminder']),
    'notifAchievement' => bool_value($user['notif_achievement']),
    'notifWeekly' => bool_value($user['notif_weekly']),
    'notifMotivasi' => bool_value($user['notif_motivasi']),
    'reminderTime' => $user['reminder_time'],
    'dndStart' => $user['dnd_start'],
    'dndEnd' => $user['dnd_end'],
    'summary' => $summary,
    'activities' => $profileActivities,
    'achievements' => $achievements,
    'sessions' => $sessions,
];

json_response([
    'success' => true,
    'message' => 'Bootstrap berhasil',
    'data' => [
        'user' => [
            'id' => int_value($user['id']),
            'name' => $user['name'],
            'username' => $user['username'],
            'email' => $user['email'],
            'role' => $user['role'],
            'avatarUrl' => $user['avatar_url'],
        ],
        'summary' => $summary,
        'dashboard' => [
            'greeting' => 'Selamat Siang',
            'subtitle' => 'Pantau perkembangan targetmu hari ini',
            'motivation' => $dashboardMotivation,
            'todayTargets' => $todayTargets,
        ],
        'targets' => $todayTargets,
        'categories' => $categories,
        'quotes' => $quotes,
        'report' => [
            'completion' => float_value($summary['averageCompletion']) / 100,
            'completionLabel' => number_format(float_value($summary['averageCompletion']), 0) . '%',
            'categoryProgress' => $reportCategoryProgress,
            'targets' => $reportTargets,
            'trends' => $reportTrends,
        ],
        'calendar' => [
            'monthLabel' => $user['calendar_month_label'],
            'currentMonth' => int_value($user['calendar_month']),
            'currentYear' => int_value($user['calendar_year']),
            'selectedDay' => int_value($user['calendar_selected_day']),
            'entries' => $calendarEntries,
            'deadlines' => $deadlines,
            'summary' => $summary,
        ],
        'profile' => $profile,
        'notificationsCount' => int_value($user['notifications_count']),
    ],
]);
