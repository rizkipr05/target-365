import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

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
  static const Duration _timeout = Duration(seconds: 15);
  static const List<int> _localBackendPorts = [8090, 8091, 8092];
  String? _workingBaseUrl;
  Process? _localBackendProcess;
  Future<String?>? _localBackendBaseUrlFuture;

  List<String> get _baseUrlCandidates {
    final candidates = <String>[
      if (_workingBaseUrl != null && _workingBaseUrl!.isNotEmpty) _workingBaseUrl!,
      ...AppConfig.apiBaseUrlCandidates,
    ];

    final seen = <String>{};
    return [
      for (final candidate in candidates)
        if (seen.add(candidate)) candidate,
    ];
  }

  bool get _supportsLocalPhpBackend =>
      !kIsWeb &&
      (Platform.isLinux || Platform.isMacOS || Platform.isWindows) &&
      !AppConfig.hasExplicitApiBaseUrl;

  Directory? _findLocalBackendDir() {
    final visited = <String>{};
    var current = Directory.current;

    while (visited.add(current.path)) {
      final candidate = File(
        '${current.path}${Platform.pathSeparator}backend${Platform.pathSeparator}api${Platform.pathSeparator}login.php',
      );
      if (candidate.existsSync()) {
        return candidate.parent;
      }

      final parent = current.parent;
      if (parent.path == current.path) {
        break;
      }
      current = parent;
    }

    return null;
  }

  Future<String?> _ensureLocalBackendBaseUrl() async {
    if (!_supportsLocalPhpBackend) {
      return null;
    }

    final cached = _localBackendBaseUrlFuture;
    if (cached != null) {
      return cached;
    }

    final future = _startLocalPhpBackend();
    _localBackendBaseUrlFuture = future;
    return future;
  }

  Future<String?> _startLocalPhpBackend() async {
    final backendDir = _findLocalBackendDir();
    if (backendDir == null) {
      return null;
    }

    for (final port in _localBackendPorts) {
      Process? process;
      try {
        process = await Process.start(
          'php',
          ['-S', '127.0.0.1:$port', '-t', backendDir.path],
          workingDirectory: backendDir.parent.path,
          runInShell: false,
        );
        process.stdout.listen((_) {});
        process.stderr.listen((_) {});

        _localBackendProcess?.kill();
        _localBackendProcess = process;

        for (var attempt = 0; attempt < 10; attempt++) {
          await Future<void>.delayed(const Duration(milliseconds: 250));
          try {
            final probe = await _client
                .get(Uri.parse('http://127.0.0.1:$port/login.php'))
                .timeout(const Duration(seconds: 2));
            if (probe.statusCode != 404) {
              return 'http://127.0.0.1:$port';
            }
          } on Object {
            // Try again while the PHP server is still booting.
          }
        }
      } on Object {
        process?.kill();
      }
    }

    return null;
  }

  Uri _uriForBase(
    String baseUrl,
    String path, [
    Map<String, dynamic>? queryParameters,
  ]) {
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$normalizedBase/$path').replace(
      queryParameters: queryParameters,
    );
  }

  Future<http.Response> _requestWithFallback(
    Future<http.Response> Function(String baseUrl) requestBuilder,
  ) async {
    Object? lastError;
    http.Response? lastResponse;
    final localBackendBaseUrl = await _ensureLocalBackendBaseUrl();

    for (final baseUrl in _baseUrlCandidates) {
      try {
        final response = await requestBuilder(baseUrl).timeout(_timeout);
        if (response.statusCode == 404) {
          lastResponse = response;
          continue;
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          _workingBaseUrl = baseUrl;
        }
        return response;
      } on http.ClientException catch (error) {
        lastError = error;
      } on SocketException catch (error) {
        lastError = error;
      } on TimeoutException catch (error) {
        lastError = error;
      }
    }

    if (localBackendBaseUrl != null) {
      try {
        final response = await requestBuilder(localBackendBaseUrl).timeout(_timeout);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _workingBaseUrl = localBackendBaseUrl;
        }
        return response;
      } on http.ClientException catch (error) {
        lastError = error;
      } on SocketException catch (error) {
        lastError = error;
      } on TimeoutException catch (error) {
        lastError = error;
      }
    }

    if (lastResponse != null) {
      return lastResponse;
    }

    throw ApiException(
      'Request gagal: ${lastError?.toString() ?? 'semua endpoint tidak tersedia'}',
    );
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
    final response = await _requestWithFallback((baseUrl) {
      final uri = _uriForBase(baseUrl, path, queryParameters);

      switch (method) {
        case 'GET':
          return _client.get(uri, headers: _headers());
        case 'POST':
          return _client.post(
            uri,
            headers: _headers(jsonBody: true),
            body: jsonEncode(body ?? const {}),
          );
        case 'PUT':
          return _client.put(
            uri,
            headers: _headers(jsonBody: true),
            body: jsonEncode(body ?? const {}),
          );
        case 'DELETE':
          return _client.delete(uri, headers: _headers());
        default:
          throw const ApiException('Unsupported HTTP method');
      }
    });

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

    final response = await _requestWithFallback((baseUrl) async {
      final request = http.MultipartRequest(
        'POST',
        _uriForBase(baseUrl, 'profile_avatar_upload.php'),
      );
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
      return http.Response.fromStream(streamed);
    });
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

  Future<void> updateTarget(Map<String, dynamic> payload) async {
    await _requestJson('POST', 'target_update.php', body: payload);
  }

  Future<void> deleteTarget({
    required int userId,
    required int id,
  }) async {
    await _requestJson(
      'POST',
      'target_delete.php',
      body: {
        'userId': userId,
        'id': id,
      },
    );
  }

  Future<void> createCategory(Map<String, dynamic> payload) async {
    await _requestJson('POST', 'category_create.php', body: payload);
  }

  Future<void> updateCategory(Map<String, dynamic> payload) async {
    await _requestJson('POST', 'category_update.php', body: payload);
  }

  Future<void> deleteCategory({
    required int userId,
    required int id,
  }) async {
    await _requestJson(
      'POST',
      'category_delete.php',
      body: {
        'userId': userId,
        'id': id,
      },
    );
  }

  Future<void> createMotivation(Map<String, dynamic> payload) async {
    await _requestJson('POST', 'motivation_create.php', body: payload);
  }

  Future<void> toggleMotivationLike({
    required int userId,
    required int quoteId,
    required bool liked,
  }) async {
    await _requestJson(
      'POST',
      'motivation_toggle_like.php',
      body: {
        'userId': userId,
        'quoteId': quoteId,
        'liked': liked,
      },
    );
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
