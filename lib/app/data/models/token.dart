import 'package:awesome_app/app/data/models/user.dart';

class Token {
  final String token;
  final User user;

  const Token({
    required this.token,
    required this.user,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }
}
