import 'package:awesome_app/base_configs/configs/app_config.dart';

abstract class ApiConfig {
  ApiConfig._();

  static const String baseUrl = AppConfig.baseUrl;

  // Header Parameters
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String accessToken = 'access_token';
  static const String bearer = 'Bearer';

  // Api End Points
  static const String user = 'user';
  static const String login = 'user/login';
  static const String register = 'user/register';
  static const String myUsers = 'user/myUsers';
  static const String addUser = 'user/addUser';
  static const String removeUser = 'removeUser';
  static const String updateUser = 'updateUser';
  static const String upload = 'upload';

  // Api Parameters
  static const String email = 'email';
  static const String password = 'password';
  static const String name = 'name';
  static const String profile = 'profile';
}
