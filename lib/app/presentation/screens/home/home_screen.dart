// ignore_for_file: use_build_context_synchronously

import 'package:awesome_app/app/data/models/myUser.dart';
import 'package:awesome_app/app/data/network/api_client.dart';
import 'package:awesome_app/app/data/riverpod/my_user_notifier.dart';
import 'package:awesome_app/app/data/riverpod/token_notifier.dart';
import 'package:awesome_app/app/presentation/screens/add_edit_user/add_edit_user.dart';
import 'package:awesome_app/base_configs/configs/string_config.dart';
import 'package:awesome_app/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void fetchMyUsers() {
    TokenNotifier tokenNotifier = ref.read(tokenNotifierProvider.notifier);

    ApiClient.withToken(context, tokenNotifier).getMyUsersApi().then((value) {
      ref
          .read(myUserNotifierProvider.notifier)
          .setMyUsers(usersFromJson(value.data));

      setState(() {});
    }).onError((error, stackTrace) {
      CommonMethods.showAlert(context, (error.toString()));
    });
  }

  void deleteMyUser(String id) {
    TokenNotifier tokenNotifier = ref.read(tokenNotifierProvider.notifier);

    ApiClient.withToken(context, tokenNotifier)
        .deleteMyUserApi(id)
        .then((value) {
      ref.read(myUserNotifierProvider.notifier).deleteSingleMyUser(id);
      setState(() {});
    }).onError((error, stackTrace) {
      CommonMethods.showAlert(context, (error.toString()));
    });
  }

  void onItemTap(MyUser user) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddEditUser(user: user)))
        .then((val) {
      if (val is bool) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    fetchMyUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<MyUser> usersList =
        ref.watch(myUserNotifierProvider.notifier).getMyUsers();

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddEditUser()))
                .then((val) {
              if (val is bool) {
                setState(() {});
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.logout,
          ),
          onPressed: () {
            CommonMethods.resetToStartUp(context);
          },
        )
      ], title: const Text(StringConfig.usersText)),
      body: Container(
        child: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            return HomeListItem(
                user: usersList[index],
                index: index,
                onItemTap: () => onItemTap(usersList[index]),
                onDeleteTap: () => deleteMyUser(usersList[index].id));
          },
        ),
      ),
    );
  }
}

class HomeListItem extends StatelessWidget {
  const HomeListItem(
      {super.key,
      required this.user,
      required this.index,
      required this.onDeleteTap,
      required this.onItemTap});

  final MyUser user;
  final int index;
  final Function onDeleteTap;
  final Function onItemTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => {onItemTap()},
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(34),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 24,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text(user.email,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.black)),
                  ],
                )
              ],
            ),
            InkWell(
              onTap: () => {onDeleteTap()},
              child: const Icon(
                Icons.delete,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
