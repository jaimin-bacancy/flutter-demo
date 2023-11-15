import 'package:awesome_app/base_configs/configs/app_config.dart';

abstract class ApiConfig {
  ApiConfig._();

  static const String baseUrl = AppConfig.baseUrl;

  // Header Parameters
  static const String authorization = 'Authorization';
  static const String accessToken = 'access_token';
  static const String bearer = 'Bearer';

  // Api End Points
  static const String login = 'user/login';
  static const String register = 'user/register';

  // Api Parameters
  static const String email = 'email';
  static const String password = 'password';
  static const String name = 'name';
}
