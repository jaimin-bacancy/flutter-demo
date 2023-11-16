import 'package:awesome_app/app/data/models/user.dart';
import 'package:awesome_app/app/data/network/api_client.dart';
import 'package:awesome_app/app/presentation/screens/add_edit_user/add_edit_user.dart';
import 'package:awesome_app/app/presentation/screens/startup/startup_screen.dart';
import 'package:awesome_app/base_configs/configs/string_config.dart';
import 'package:awesome_app/utils/common_methods.dart';
import 'package:awesome_app/utils/shared_pref_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> _usersList = [];

  void fetchMyUsers() {
    ApiClient().getMyUsersApi().then((value) {
      List<User> list = usersFromJson(value.data);
      setState(() {
        _usersList = list;
      });
    }).onError((error, stackTrace) {
      CommonMethods.showAlert(context, (error.toString()));
    });
  }

  void deleteMyUser(String id) {
    ApiClient().deleteMyUserApi(id).then((value) {
      List<User> list = usersFromJson(value.data);
      setState(() {
        _usersList = list;
      });
    }).onError((error, stackTrace) {
      CommonMethods.showAlert(context, (error.toString()));
    });
  }

  void onItemTap(User user) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddEditUser(user: user)))
        .then((val) {
      if (val is bool) {
        fetchMyUsers();
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
                fetchMyUsers();
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.logout,
          ),
          onPressed: () async {
            await SharedPrefUtils().clearSharedPref();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StartupScreen(),
              ),
            );
          },
        )
      ], title: const Text(StringConfig.usersText)),
      body: Container(
        child: ListView.builder(
          itemCount: _usersList.length,
          itemBuilder: (context, index) {
            return HomeListItem(
                user: _usersList[index],
                index: index,
                onItemTap: () => onItemTap(_usersList[index]),
                onDeleteTap: () => deleteMyUser(_usersList[index].id));
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

  final User user;
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
