import '../models/app_models.dart';

class AppSession {
  AppSession._();

  static final AppSession instance = AppSession._();

  SessionUser? user;
  String? token;
  AppBootstrap? bootstrap;

  bool get isLoggedIn => token != null && user != null;

  void update({
    required SessionUser user,
    required String token,
  }) {
    this.user = user;
    this.token = token;
  }

  void cacheBootstrap(AppBootstrap bootstrap) {
    this.bootstrap = bootstrap;
  }

  void clear() {
    user = null;
    token = null;
    bootstrap = null;
  }
}

