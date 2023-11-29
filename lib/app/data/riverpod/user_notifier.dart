import 'package:awesome_app/app/data/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  User? build() {
    return null;
  }

  void setCurrentUser(User user) {
    state = user;
  }

  User? getCurrentUser() {
    return state;
  }
}
