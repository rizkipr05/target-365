import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _defineApiBaseUrl = String.fromEnvironment(
    'TARGET365_API_BASE_URL',
    defaultValue: '',
  );

  static bool get hasExplicitApiBaseUrl => _defineApiBaseUrl.isNotEmpty;

  static String get apiBaseUrl {
    final candidates = apiBaseUrlCandidates;
    return candidates.first;
  }

  static List<String> get apiBaseUrlCandidates {
    if (_defineApiBaseUrl.isNotEmpty) {
      return [_defineApiBaseUrl];
    }

    const paths = <String>[
      'target365_api/api',
      'target365_app/backend/api',
      'backend/api',
      'api',
    ];

    String hostForPlatform() {
      if (kIsWeb) {
        return '127.0.0.1';
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return '10.0.2.2';
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.fuchsia:
          return '127.0.0.1';
      }
    }

    final host = hostForPlatform();
    return [
      for (final path in paths) 'http://$host:8080/$path',
    ];
  }
}
