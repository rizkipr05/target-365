import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _defineApiBaseUrl = String.fromEnvironment(
    'TARGET365_API_BASE_URL',
    defaultValue: '',
  );

  static String get apiBaseUrl {
    if (_defineApiBaseUrl.isNotEmpty) {
      return _defineApiBaseUrl;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8080/target365_api/api';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8080/target365_api/api';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return 'http://127.0.0.1:8080/target365_api/api';
      case TargetPlatform.fuchsia:
        return 'http://127.0.0.1:8080/target365_api/api';
    }
  }
}
