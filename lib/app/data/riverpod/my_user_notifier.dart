import 'package:awesome_app/app/data/models/myUser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_user_notifier.g.dart';

@riverpod
class MyUserNotifier extends _$MyUserNotifier {
  @override
  List<MyUser> build() {
    return [];
  }

  void setMyUsers(List<MyUser> myUser) {
    state = myUser;
  }

  void deleteSingleMyUser(String id) {
    state.removeWhere((e) => e.id == id);
  }

  void addNewMyUser(MyUser myUser) {
    state.add(myUser);
  }

  void updateMyUser(MyUser myUser) {
    int index = state.indexWhere((element) => element.id == myUser.id);
    if (index > -1) {
      state[index] = myUser;
    }
  }

  List<MyUser> getMyUsers() {
    return state;
  }
}
