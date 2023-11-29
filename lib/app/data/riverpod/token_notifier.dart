import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_notifier.g.dart';

@Riverpod()
class TokenNotifier extends _$TokenNotifier {
  final _storage = GetStorage();
  final _key = "token";

  @override
  String build() {
    final token = _storage.read(_key);

    return token ?? "";
  }

  void setAuthToken(String token) {
    _storage.write(_key, token);
  }

  String? getAuthToken() {
    final token = _storage.read(_key);

    return token ?? "";
  }
}
