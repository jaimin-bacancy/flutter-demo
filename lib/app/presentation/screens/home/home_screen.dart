// ignore_for_file: use_build_context_synchronously

import 'package:awesome_app/app/data/models/myUser.dart';
import 'package:awesome_app/app/data/models/pagination_data.dart';
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
  bool _isLoading = false;
  int _total = 0;
  int _offset = 0;
  String searchText = "";

  void fetchMyUsers(String searchText, int offset) {
    TokenNotifier tokenNotifier = ref.read(tokenNotifierProvider.notifier);
    setState(() {
      _isLoading = true;
    });

    ApiClient.withToken(context, tokenNotifier)
        .getMyUsersApi(searchText, offset)
        .then((value) {
      List<MyUser> users =
          paginationDataFromJson<MyUser>(value.data.items, MyUser.fromJson);

      List<MyUser> prevData =
          ref.read(myUserNotifierProvider.notifier).getMyUsers();

      prevData.addAll(users);
      ref.read(myUserNotifierProvider.notifier).setMyUsers(prevData);

      setState(() {
        _isLoading = false;
        _total = value.data.pagination.total;
        _offset = value.data.pagination.offset;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
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
    fetchMyUsers("", 0);
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
        body: Column(
          children: [
            SearchInput(
              fetchMyUsers: fetchMyUsers,
              searchText: searchText,
            ),
            Expanded(
              flex: 1,
              child: HomeList(
                  searchText: searchText,
                  offset: _offset,
                  total: _total,
                  isLoading: _isLoading,
                  deleteMyUser: deleteMyUser,
                  onItemTap: onItemTap,
                  fetchMyUsers: fetchMyUsers),
            )
          ],
        ));
  }
}

class SearchInput extends ConsumerStatefulWidget {
  SearchInput(
      {super.key, required this.fetchMyUsers, required this.searchText});

  final Function fetchMyUsers;
  String searchText;

  @override
  ConsumerState<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends ConsumerState<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          widget.searchText = value;
          ref.read(myUserNotifierProvider.notifier).setMyUsers([]);
          widget.fetchMyUsers(value, 0);
        },
        decoration: const InputDecoration(
            hintText: StringConfig.searchUserText,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }
}

class HomeList extends ConsumerStatefulWidget {
  const HomeList({
    super.key,
    required this.isLoading,
    required this.total,
    required this.offset,
    required this.onItemTap,
    required this.deleteMyUser,
    required this.fetchMyUsers,
    required this.searchText,
  });

  final Function deleteMyUser;
  final Function onItemTap;
  final Function fetchMyUsers;
  final bool isLoading;
  final int total;
  final int offset;
  final String searchText;

  @override
  ConsumerState<HomeList> createState() => _HomeListState();
}

class _HomeListState extends ConsumerState<HomeList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.maxScrollExtent ==
              scrollController.offset) &&
          !widget.isLoading) {
        if (widget.total >= widget.offset + 10) {
          widget.fetchMyUsers(widget.searchText, widget.offset + 10);
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MyUser> usersList =
        ref.watch(myUserNotifierProvider.notifier).getMyUsers();

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.amber,
      strokeWidth: 2.0,
      onRefresh: () async {
        ref.read(myUserNotifierProvider.notifier).setMyUsers([]);
        widget.fetchMyUsers("", 0);

        return;
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          return HomeListItem(
              user: usersList[index],
              index: index,
              onItemTap: () => widget.onItemTap(usersList[index]),
              onDeleteTap: () => widget.deleteMyUser(usersList[index].id));
        },
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
                // Container(
                //   padding: const EdgeInsets.all(10),
                //   margin: const EdgeInsets.only(right: 10),
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       width: 1,
                //     ),
                //     borderRadius: BorderRadius.circular(34),
                //   ),
                //   child: const Icon(
                //     Icons.person,
                //     size: 24,
                //   ),
                // ),
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
                    Text(
                        "${CommonMethods.convertDateToAge(user.dob).toString()} years",
                        maxLines: 1,
                        style: const TextStyle(color: Colors.black))
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
