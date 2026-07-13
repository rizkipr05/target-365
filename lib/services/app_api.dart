import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/app_models.dart';
import '../state/app_session.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class AppApi {
  AppApi._();

  static final AppApi instance = AppApi._();

  final http.Client _client = http.Client();

  Uri _uri(String path, [Map<String, dynamic>? queryParameters]) {
    final base = AppConfig.apiBaseUrl.endsWith('/')
        ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
        : AppConfig.apiBaseUrl;
    return Uri.parse('$base/$path').replace(queryParameters: queryParameters);
  }

  Map<String, String> _headers({bool jsonBody = false}) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (jsonBody) {
      headers['Content-Type'] = 'application/json';
    }
    final token = AppSession.instance.token;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<ApiResponse<Map<String, dynamic>>> _requestJson(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _uri(path, queryParameters);
    late http.Response response;

    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: _headers());
        break;
      case 'POST':
        response = await _client.post(
          uri,
          headers: _headers(jsonBody: true),
          body: jsonEncode(body ?? const {}),
        );
        break;
      case 'PUT':
        response = await _client.put(
          uri,
          headers: _headers(jsonBody: true),
          body: jsonEncode(body ?? const {}),
        );
        break;
      case 'DELETE':
        response = await _client.delete(uri, headers: _headers());
        break;
      default:
        throw const ApiException('Unsupported HTTP method');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Request gagal (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Format response API tidak valid');
    }

    return ApiResponse<Map<String, dynamic>>(
      success: decoded['success'] != false,
      message: decoded['message']?.toString() ?? '',
      data: Map<String, dynamic>.from(decoded['data'] ?? const {}),
    );
  }

  Future<SessionUser> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await _requestJson(
      'POST',
      'login.php',
      body: {
        'email': email,
        'password': password,
        'rememberMe': rememberMe,
      },
    );

    final user = SessionUser.fromJson(Map<String, dynamic>.from(response.data['user'] ?? const {}));
    final token = response.data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw const ApiException('Token login tidak ditemukan');
    }

    AppSession.instance.update(user: user, token: token);
    return user;
  }

  Future<AppBootstrap> bootstrap(int userId) async {
    final response = await _requestJson(
      'GET',
      'bootstrap.php',
      queryParameters: {'userId': '$userId'},
    );
    final bootstrap = AppBootstrap.fromJson(response.data);
    AppSession.instance.cacheBootstrap(bootstrap);
    return bootstrap;
  }

  Future<AppBootstrap> refreshBootstrap() async {
    final user = AppSession.instance.user;
    if (user == null) {
      throw const ApiException('Sesi login tidak ditemukan');
    }
    return bootstrap(user.id);
  }

  Future<ProfileData> updateProfile(Map<String, dynamic> payload) async {
    final response = await _requestJson(
      'POST',
      'profile_update.php',
      body: payload,
    );
    final profile = ProfileData.fromJson(response.data);
    final cached = AppSession.instance.bootstrap;
    if (cached != null) {
      AppSession.instance.cacheBootstrap(
        AppBootstrap(
          user: cached.user,
          summary: cached.summary,
          dashboard: cached.dashboard,
          targets: cached.targets,
          categories: cached.categories,
          quotes: cached.quotes,
          report: cached.report,
          calendar: cached.calendar,
          profile: profile,
          notificationsCount: cached.notificationsCount,
        ),
      );
    }
    return profile;
  }

  Future<ProfileData> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _requestJson(
      'POST',
      'password_update.php',
      body: {
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    return refreshProfile();
  }

  Future<ProfileData> refreshProfile() async {
    final refreshed = await refreshBootstrap();
    return refreshed.profile;
  }

  Future<ProfileData> updateAvatarUrl({
    required int userId,
    required String avatarUrl,
  }) async {
    return updateProfile({
      'userId': userId,
      'avatarUrl': avatarUrl,
    });
  }

  Future<ProfileData> uploadProfileAvatar({
    required int userId,
    required String filePath,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw const ApiException('File foto tidak ditemukan');
    }

    final request = http.MultipartRequest('POST', _uri('profile_avatar_upload.php'));
    request.headers.addAll(_headers());
    request.fields['userId'] = '$userId';
    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar',
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Request gagal (${response.statusCode}): ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Format response API tidak valid');
    }

    final avatarUrl = decoded['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(decoded['data'] as Map)['avatarUrl']?.toString()
        : null;
    if (avatarUrl == null || avatarUrl.isEmpty) {
      throw const ApiException('Avatar URL tidak ditemukan');
    }

    final refreshed = await refreshBootstrap();
    return refreshed.profile;
  }

  Future<ReportExportData> exportReport({required int userId}) async {
    final response = await _requestJson(
      'GET',
      'report_export.php',
      queryParameters: {'userId': '$userId'},
    );
    return ReportExportData.fromJson(response.data);
  }

  Future<void> createTarget(Map<String, dynamic> payload) async {
    await _requestJson('POST', 'target_create.php', body: payload);
  }

  Future<void> createCategory(Map<String, dynamic> payload) async {
    await _requestJson('POST', 'category_create.php', body: payload);
  }

  Future<void> createMotivation(Map<String, dynamic> payload) async {
    await _requestJson('POST', 'motivation_create.php', body: payload);
  }

  Future<CalendarEntry> saveCalendarEvent(Map<String, dynamic> payload) async {
    final response = await _requestJson(
      'POST',
      'calendar_event_save.php',
      body: payload,
    );
    return CalendarEntry.fromJson(response.data);
  }

  Future<void> deleteCalendarEvent({
    required int userId,
    required int id,
  }) async {
    await _requestJson(
      'POST',
      'calendar_event_delete.php',
      body: {
        'userId': userId,
        'id': id,
      },
    );
  }
}
