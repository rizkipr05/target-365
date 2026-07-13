import 'package:flutter/material.dart';

Color colorFromHex(String hex, {Color fallback = Colors.transparent}) {
  var value = hex.replaceAll('#', '').trim();
  if (value.length == 6) {
    value = 'FF$value';
  }
  if (value.length != 8) {
    return fallback;
  }
  return Color(int.parse(value, radix: 16));
}

String colorToHex(Color color) {
  final value = color.value.toRadixString(16).padLeft(8, '0');
  return '#${value.substring(2).toUpperCase()}';
}

IconData iconFromName(String name) {
  switch (name) {
    case 'track_changes_rounded':
      return Icons.track_changes_rounded;
    case 'check_circle_outline_rounded':
      return Icons.check_circle_outline_rounded;
    case 'timelapse_rounded':
      return Icons.timelapse_rounded;
    case 'radio_button_unchecked_rounded':
      return Icons.radio_button_unchecked_rounded;
    case 'menu_book_rounded':
      return Icons.menu_book_rounded;
    case 'fitness_center_rounded':
      return Icons.fitness_center_rounded;
    case 'savings_rounded':
      return Icons.savings_rounded;
    case 'laptop_rounded':
      return Icons.laptop_rounded;
    case 'flight_rounded':
      return Icons.flight_rounded;
    case 'eco_rounded':
      return Icons.eco_rounded;
    case 'favorite_rounded':
      return Icons.favorite_rounded;
    case 'account_balance_wallet_rounded':
      return Icons.account_balance_wallet_rounded;
    case 'work_rounded':
      return Icons.work_rounded;
    case 'people_rounded':
      return Icons.people_rounded;
    case 'emoji_emotions_rounded':
      return Icons.emoji_emotions_rounded;
    case 'bar_chart_rounded':
      return Icons.bar_chart_rounded;
    case 'calendar_month_rounded':
      return Icons.calendar_month_rounded;
    case 'person_outline_rounded':
      return Icons.person_outline_rounded;
    case 'settings_outlined':
      return Icons.settings_outlined;
    case 'shield_outlined':
      return Icons.shield_outlined;
    case 'tune_rounded':
      return Icons.tune_rounded;
    case 'notifications_none_rounded':
      return Icons.notifications_none_rounded;
    case 'history_rounded':
      return Icons.history_rounded;
    case 'check_rounded':
      return Icons.check_rounded;
    case 'edit_rounded':
      return Icons.edit_rounded;
    case 'add_rounded':
      return Icons.add_rounded;
    case 'emoji_events_outlined':
      return Icons.emoji_events_outlined;
    case 'bolt_rounded':
      return Icons.bolt_rounded;
    case 'warning_amber_rounded':
      return Icons.warning_amber_rounded;
    case 'smartphone_rounded':
      return Icons.smartphone_rounded;
    case 'computer_rounded':
      return Icons.computer_rounded;
    case 'dark_mode_outlined':
      return Icons.dark_mode_outlined;
    case 'compress_rounded':
      return Icons.compress_rounded;
    case 'palette_outlined':
      return Icons.palette_outlined;
    case 'language_rounded':
      return Icons.language_rounded;
    case 'alarm_rounded':
      return Icons.alarm_rounded;
    case 'notifications_active_outlined':
      return Icons.notifications_active_outlined;
    case 'filter_list_rounded':
      return Icons.filter_list_rounded;
    case 'do_not_disturb_alt_outlined':
      return Icons.do_not_disturb_alt_outlined;
    case 'info_outline_rounded':
      return Icons.info_outline_rounded;
    case 'photo_camera_outlined':
      return Icons.photo_camera_outlined;
    case 'manage_accounts_outlined':
      return Icons.manage_accounts_outlined;
    case 'lock_outline_rounded':
      return Icons.lock_outline_rounded;
    case 'verified_user_outlined':
      return Icons.verified_user_outlined;
    case 'devices_rounded':
      return Icons.devices_rounded;
    case 'phone_outlined':
      return Icons.phone_outlined;
    case 'mail_outline_rounded':
      return Icons.mail_outline_rounded;
    case 'alternate_email_rounded':
      return Icons.alternate_email_rounded;
    case 'cake_outlined':
      return Icons.cake_outlined;
    case 'wc_rounded':
      return Icons.wc_rounded;
    case 'location_on_outlined':
      return Icons.location_on_outlined;
    case 'logout_rounded':
      return Icons.logout_rounded;
    case 'upload_rounded':
      return Icons.upload_rounded;
    case 'save_outlined':
      return Icons.save_outlined;
    case 'lock_reset_rounded':
      return Icons.lock_reset_rounded;
    case 'security_rounded':
      return Icons.security_rounded;
    case 'devices':
      return Icons.devices;
    case 'person':
      return Icons.person;
    case 'grid_view_rounded':
      return Icons.grid_view_rounded;
    case 'folder_open_rounded':
      return Icons.folder_open_rounded;
    case 'visibility_rounded':
      return Icons.visibility_rounded;
    case 'inventory_2_rounded':
      return Icons.inventory_2_rounded;
    case 'filter_alt_outlined':
      return Icons.filter_alt_outlined;
    case 'search':
      return Icons.search;
    case 'chevron_right':
      return Icons.chevron_right;
    case 'chevron_left_rounded':
      return Icons.chevron_left_rounded;
    case 'download_rounded':
      return Icons.download_rounded;
    case 'send_rounded':
      return Icons.send_rounded;
    case 'bookmark_border_rounded':
      return Icons.bookmark_border_rounded;
    case 'share_rounded':
      return Icons.share_rounded;
    case 'calendar_today_rounded':
      return Icons.calendar_today_rounded;
    case 'filter_alt':
      return Icons.filter_alt;
    default:
      return Icons.circle;
  }
}

String _stringValue(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  return value.toString();
}

int _intValue(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  return int.tryParse(_stringValue(value)) ?? fallback;
}

double _doubleValue(dynamic value, [double fallback = 0]) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(_stringValue(value)) ?? fallback;
}

bool _boolValue(dynamic value, [bool fallback = false]) {
  if (value is bool) return value;
  final raw = _stringValue(value).toLowerCase();
  if (raw == 'true' || raw == '1' || raw == 'yes') return true;
  if (raw == 'false' || raw == '0' || raw == 'no') return false;
  return fallback;
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T data;

  const ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data) parser,
  ) {
    return ApiResponse<T>(
      success: _boolValue(json['success'], true),
      message: _stringValue(json['message']),
      data: parser(json['data']),
    );
  }
}

class SessionUser {
  final int id;
  final String name;
  final String username;
  final String email;
  final String role;
  final String avatarUrl;

  const SessionUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.avatarUrl,
  });

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      username: _stringValue(json['username']),
      email: _stringValue(json['email']),
      role: _stringValue(json['role'], 'Pengguna'),
      avatarUrl: _stringValue(json['avatarUrl']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'role': role,
        'avatarUrl': avatarUrl,
      };

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}

class SummaryStats {
  final int totalTargets;
  final int completedTargets;
  final int inProgressTargets;
  final int notStartedTargets;
  final double averageCompletion;

  const SummaryStats({
    required this.totalTargets,
    required this.completedTargets,
    required this.inProgressTargets,
    required this.notStartedTargets,
    required this.averageCompletion,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) {
    return SummaryStats(
      totalTargets: _intValue(json['totalTargets']),
      completedTargets: _intValue(json['completedTargets']),
      inProgressTargets: _intValue(json['inProgressTargets']),
      notStartedTargets: _intValue(json['notStartedTargets']),
      averageCompletion: _doubleValue(json['averageCompletion']),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalTargets': totalTargets,
        'completedTargets': completedTargets,
        'inProgressTargets': inProgressTargets,
        'notStartedTargets': notStartedTargets,
        'averageCompletion': averageCompletion,
      };

  String get completedPercentLabel => '${(completedTargets / totalTargets * 100).toStringAsFixed(2)}%';
  String get inProgressPercentLabel => '${(inProgressTargets / totalTargets * 100).toStringAsFixed(2)}%';
  String get notStartedPercentLabel => '${(notStartedTargets / totalTargets * 100).toStringAsFixed(2)}%';
}

class TargetItem {
  final int id;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String category;
  final Color categoryColor;
  final String priority;
  final String deadline;
  final double progress;
  final String progressLabel;
  final String status;
  final Color statusColor;

  const TargetItem({
    required this.id,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.priority,
    required this.deadline,
    required this.progress,
    required this.progressLabel,
    required this.status,
    required this.statusColor,
  });

  factory TargetItem.fromJson(Map<String, dynamic> json) {
    return TargetItem(
      id: _intValue(json['id']),
      icon: iconFromName(_stringValue(json['icon'])),
      iconBg: colorFromHex(_stringValue(json['iconBg'])),
      iconColor: colorFromHex(_stringValue(json['iconColor'])),
      title: _stringValue(json['title']),
      category: _stringValue(json['category']),
      categoryColor: colorFromHex(_stringValue(json['categoryColor'])),
      priority: _stringValue(json['priority']),
      deadline: _stringValue(json['deadline']),
      progress: _doubleValue(json['progress']),
      progressLabel: _stringValue(json['progressLabel']),
      status: _stringValue(json['status']),
      statusColor: colorFromHex(_stringValue(json['statusColor'])),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'icon': icon.fontFamily,
        'iconBg': colorToHex(iconBg),
        'iconColor': colorToHex(iconColor),
        'title': title,
        'category': category,
        'categoryColor': colorToHex(categoryColor),
        'priority': priority,
        'deadline': deadline,
        'progress': progress,
        'progressLabel': progressLabel,
        'status': status,
        'statusColor': colorToHex(statusColor),
      };
}

class CategoryItem {
  final int id;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String name;
  final String description;
  final String jumlahTarget;
  final String status;

  const CategoryItem({
    required this.id,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.name,
    required this.description,
    required this.jumlahTarget,
    required this.status,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: _intValue(json['id']),
      icon: iconFromName(_stringValue(json['icon'])),
      iconBg: colorFromHex(_stringValue(json['iconBg'])),
      iconColor: colorFromHex(_stringValue(json['iconColor'])),
      name: _stringValue(json['name']),
      description: _stringValue(json['description']),
      jumlahTarget: _stringValue(json['jumlahTarget']),
      status: _stringValue(json['status'], 'Aktif'),
    );
  }
}

class MotivationQuote {
  final int id;
  final String category;
  final Color categoryColor;
  final String text;
  final String date;
  final bool liked;

  const MotivationQuote({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.text,
    required this.date,
    required this.liked,
  });

  factory MotivationQuote.fromJson(Map<String, dynamic> json) {
    return MotivationQuote(
      id: _intValue(json['id']),
      category: _stringValue(json['category']),
      categoryColor: colorFromHex(_stringValue(json['categoryColor'])),
      text: _stringValue(json['text']),
      date: _stringValue(json['date']),
      liked: _boolValue(json['liked']),
    );
  }
}

class DashboardMotivation {
  final String title;
  final String quote;
  final String author;

  const DashboardMotivation({
    required this.title,
    required this.quote,
    required this.author,
  });

  factory DashboardMotivation.fromJson(Map<String, dynamic> json) {
    return DashboardMotivation(
      title: _stringValue(json['title'], 'Motivasi Hari Ini'),
      quote: _stringValue(json['quote']),
      author: _stringValue(json['author'], 'Target365'),
    );
  }
}

class DashboardData {
  final String greeting;
  final String subtitle;
  final DashboardMotivation motivation;
  final List<TargetItem> todayTargets;

  const DashboardData({
    required this.greeting,
    required this.subtitle,
    required this.motivation,
    required this.todayTargets,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      greeting: _stringValue(json['greeting'], 'Selamat Siang'),
      subtitle: _stringValue(json['subtitle'], 'Pantau perkembangan targetmu hari ini'),
      motivation: DashboardMotivation.fromJson(Map<String, dynamic>.from(json['motivation'] ?? const {})),
      todayTargets: (json['todayTargets'] as List<dynamic>? ?? const [])
          .map((item) => TargetItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class ReportCategoryProgress {
  final String name;
  final Color color;
  final int percent;
  final String targetSummary;

  const ReportCategoryProgress({
    required this.name,
    required this.color,
    required this.percent,
    required this.targetSummary,
  });

  factory ReportCategoryProgress.fromJson(Map<String, dynamic> json) {
    return ReportCategoryProgress(
      name: _stringValue(json['name']),
      color: colorFromHex(_stringValue(json['color'])),
      percent: _intValue(json['percent']),
      targetSummary: _stringValue(json['targetSummary']),
    );
  }
}

class ReportTargetRow {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String category;
  final Color categoryColor;
  final String priority;
  final String deadline;
  final double progress;
  final String status;
  final Color statusColor;

  const ReportTargetRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.priority,
    required this.deadline,
    required this.progress,
    required this.status,
    required this.statusColor,
  });

  factory ReportTargetRow.fromJson(Map<String, dynamic> json) {
    return ReportTargetRow(
      icon: iconFromName(_stringValue(json['icon'])),
      iconColor: colorFromHex(_stringValue(json['iconColor'])),
      title: _stringValue(json['title']),
      category: _stringValue(json['category']),
      categoryColor: colorFromHex(_stringValue(json['categoryColor'])),
      priority: _stringValue(json['priority']),
      deadline: _stringValue(json['deadline']),
      progress: _doubleValue(json['progress']),
      status: _stringValue(json['status']),
      statusColor: colorFromHex(_stringValue(json['statusColor'])),
    );
  }
}

class ReportTrendPoint {
  final String label;
  final int value;

  const ReportTrendPoint({
    required this.label,
    required this.value,
  });

  factory ReportTrendPoint.fromJson(Map<String, dynamic> json) {
    return ReportTrendPoint(
      label: _stringValue(json['label']),
      value: _intValue(json['value']),
    );
  }
}

class ReportData {
  final double completion;
  final String completionLabel;
  final List<ReportCategoryProgress> categoryProgress;
  final List<ReportTargetRow> targets;
  final List<ReportTrendPoint> trends;

  const ReportData({
    required this.completion,
    required this.completionLabel,
    required this.categoryProgress,
    required this.targets,
    required this.trends,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      completion: _doubleValue(json['completion']),
      completionLabel: _stringValue(json['completionLabel']),
      categoryProgress: (json['categoryProgress'] as List<dynamic>? ?? const [])
          .map((item) => ReportCategoryProgress.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      targets: (json['targets'] as List<dynamic>? ?? const [])
          .map((item) => ReportTargetRow.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      trends: (json['trends'] as List<dynamic>? ?? const [])
          .map((item) => ReportTrendPoint.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class ReportExportData {
  final String filename;
  final String content;

  const ReportExportData({
    required this.filename,
    required this.content,
  });

  factory ReportExportData.fromJson(Map<String, dynamic> json) {
    return ReportExportData(
      filename: _stringValue(json['filename'], 'target365-report.csv'),
      content: _stringValue(json['content']),
    );
  }
}

class CalendarEntry {
  final int id;
  final int day;
  final String title;
  final Color color;
  final String time;
  final String type;

  const CalendarEntry({
    required this.id,
    required this.day,
    required this.title,
    required this.color,
    required this.time,
    required this.type,
  });

  factory CalendarEntry.fromJson(Map<String, dynamic> json) {
    return CalendarEntry(
      id: _intValue(json['id']),
      day: _intValue(json['day']),
      title: _stringValue(json['title']),
      color: colorFromHex(_stringValue(json['color'])),
      time: _stringValue(json['time']),
      type: _stringValue(json['type'], 'Target'),
    );
  }
}

class DeadlineItem {
  final Color color;
  final String title;
  final String date;
  final String remaining;

  const DeadlineItem({
    required this.color,
    required this.title,
    required this.date,
    required this.remaining,
  });

  factory DeadlineItem.fromJson(Map<String, dynamic> json) {
    return DeadlineItem(
      color: colorFromHex(_stringValue(json['color'])),
      title: _stringValue(json['title']),
      date: _stringValue(json['date']),
      remaining: _stringValue(json['remaining']),
    );
  }
}

class CalendarData {
  final String monthLabel;
  final int currentMonth;
  final int currentYear;
  final int selectedDay;
  final List<CalendarEntry> entries;
  final List<DeadlineItem> deadlines;
  final SummaryStats summary;

  const CalendarData({
    required this.monthLabel,
    required this.currentMonth,
    required this.currentYear,
    required this.selectedDay,
    required this.entries,
    required this.deadlines,
    required this.summary,
  });

  Map<int, List<CalendarEntry>> get groupedEntries {
    final map = <int, List<CalendarEntry>>{};
    for (final entry in entries) {
      map.putIfAbsent(entry.day, () => []).add(entry);
    }
    return map;
  }

  List<CalendarEntry> entriesForDay(int day) => groupedEntries[day] ?? const [];

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      monthLabel: _stringValue(json['monthLabel']),
      currentMonth: _intValue(json['currentMonth']),
      currentYear: _intValue(json['currentYear']),
      selectedDay: _intValue(json['selectedDay']),
      entries: (json['entries'] as List<dynamic>? ?? const [])
          .map((item) => CalendarEntry.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      deadlines: (json['deadlines'] as List<dynamic>? ?? const [])
          .map((item) => DeadlineItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      summary: SummaryStats.fromJson(Map<String, dynamic>.from(json['summary'] ?? const {})),
    );
  }
}

class ProfileActivity {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String title;
  final String description;
  final String time;

  const ProfileActivity({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.title,
    required this.description,
    required this.time,
  });

  factory ProfileActivity.fromJson(Map<String, dynamic> json) {
    return ProfileActivity(
      icon: iconFromName(_stringValue(json['icon'])),
      color: colorFromHex(_stringValue(json['color'])),
      backgroundColor: colorFromHex(_stringValue(json['backgroundColor'])),
      title: _stringValue(json['title']),
      description: _stringValue(json['description']),
      time: _stringValue(json['time']),
    );
  }
}

class AchievementItem {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final String date;

  const AchievementItem({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  factory AchievementItem.fromJson(Map<String, dynamic> json) {
    return AchievementItem(
      icon: iconFromName(_stringValue(json['icon'])),
      color: colorFromHex(_stringValue(json['color'])),
      backgroundColor: colorFromHex(_stringValue(json['backgroundColor'])),
      title: _stringValue(json['title']),
      subtitle: _stringValue(json['subtitle']),
      date: _stringValue(json['date']),
    );
  }
}

class ProfileSession {
  final IconData icon;
  final String title;
  final String location;
  final bool currentDevice;

  const ProfileSession({
    required this.icon,
    required this.title,
    required this.location,
    required this.currentDevice,
  });

  factory ProfileSession.fromJson(Map<String, dynamic> json) {
    return ProfileSession(
      icon: iconFromName(_stringValue(json['icon'])),
      title: _stringValue(json['title']),
      location: _stringValue(json['location']),
      currentDevice: _boolValue(json['currentDevice']),
    );
  }
}

class ProfileData {
  final String name;
  final String username;
  final String email;
  final String role;
  final String joinDate;
  final String tagline;
  final String about;
  final String birthday;
  final String gender;
  final String phone;
  final String location;
  final String avatarUrl;
  final String language;
  final String dateFormat;
  final bool darkMode;
  final bool compactView;
  final bool twoFactor;
  final bool notifPush;
  final bool notifEmail;
  final bool notifTargetReminder;
  final bool notifAchievement;
  final bool notifWeekly;
  final bool notifMotivasi;
  final String reminderTime;
  final String dndStart;
  final String dndEnd;
  final List<ProfileActivity> activities;
  final List<AchievementItem> achievements;
  final List<ProfileSession> sessions;
  final SummaryStats summary;

  const ProfileData({
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.joinDate,
    required this.tagline,
    required this.about,
    required this.birthday,
    required this.gender,
    required this.phone,
    required this.location,
    required this.avatarUrl,
    required this.language,
    required this.dateFormat,
    required this.darkMode,
    required this.compactView,
    required this.twoFactor,
    required this.notifPush,
    required this.notifEmail,
    required this.notifTargetReminder,
    required this.notifAchievement,
    required this.notifWeekly,
    required this.notifMotivasi,
    required this.reminderTime,
    required this.dndStart,
    required this.dndEnd,
    required this.activities,
    required this.achievements,
    required this.sessions,
    required this.summary,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: _stringValue(json['name']),
      username: _stringValue(json['username']),
      email: _stringValue(json['email']),
      role: _stringValue(json['role'], 'Pengguna'),
      joinDate: _stringValue(json['joinDate']),
      tagline: _stringValue(json['tagline']),
      about: _stringValue(json['about']),
      birthday: _stringValue(json['birthday']),
      gender: _stringValue(json['gender']),
      phone: _stringValue(json['phone']),
      location: _stringValue(json['location']),
      avatarUrl: _stringValue(json['avatarUrl']),
      language: _stringValue(json['language'], 'Bahasa Indonesia'),
      dateFormat: _stringValue(json['dateFormat'], 'DD/MM/YYYY'),
      darkMode: _boolValue(json['darkMode']),
      compactView: _boolValue(json['compactView']),
      twoFactor: _boolValue(json['twoFactor']),
      notifPush: _boolValue(json['notifPush']),
      notifEmail: _boolValue(json['notifEmail']),
      notifTargetReminder: _boolValue(json['notifTargetReminder']),
      notifAchievement: _boolValue(json['notifAchievement']),
      notifWeekly: _boolValue(json['notifWeekly']),
      notifMotivasi: _boolValue(json['notifMotivasi']),
      reminderTime: _stringValue(json['reminderTime'], '07:00'),
      dndStart: _stringValue(json['dndStart'], '22:00'),
      dndEnd: _stringValue(json['dndEnd'], '06:00'),
      activities: (json['activities'] as List<dynamic>? ?? const [])
          .map((item) => ProfileActivity.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      achievements: (json['achievements'] as List<dynamic>? ?? const [])
          .map((item) => AchievementItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      sessions: (json['sessions'] as List<dynamic>? ?? const [])
          .map((item) => ProfileSession.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      summary: SummaryStats.fromJson(Map<String, dynamic>.from(json['summary'] ?? const {})),
    );
  }
}

class AppBootstrap {
  final SessionUser user;
  final SummaryStats summary;
  final DashboardData dashboard;
  final List<TargetItem> targets;
  final List<CategoryItem> categories;
  final List<MotivationQuote> quotes;
  final ReportData report;
  final CalendarData calendar;
  final ProfileData profile;
  final int notificationsCount;

  const AppBootstrap({
    required this.user,
    required this.summary,
    required this.dashboard,
    required this.targets,
    required this.categories,
    required this.quotes,
    required this.report,
    required this.calendar,
    required this.profile,
    required this.notificationsCount,
  });

  factory AppBootstrap.fromJson(Map<String, dynamic> json) {
    return AppBootstrap(
      user: SessionUser.fromJson(Map<String, dynamic>.from(json['user'] ?? const {})),
      summary: SummaryStats.fromJson(Map<String, dynamic>.from(json['summary'] ?? const {})),
      dashboard: DashboardData.fromJson(Map<String, dynamic>.from(json['dashboard'] ?? const {})),
      targets: (json['targets'] as List<dynamic>? ?? const [])
          .map((item) => TargetItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      categories: (json['categories'] as List<dynamic>? ?? const [])
          .map((item) => CategoryItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      quotes: (json['quotes'] as List<dynamic>? ?? const [])
          .map((item) => MotivationQuote.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      report: ReportData.fromJson(Map<String, dynamic>.from(json['report'] ?? const {})),
      calendar: CalendarData.fromJson(Map<String, dynamic>.from(json['calendar'] ?? const {})),
      profile: ProfileData.fromJson(Map<String, dynamic>.from(json['profile'] ?? const {})),
      notificationsCount: _intValue(json['notificationsCount'], 0),
    );
  }
}
