import 'package:awesome_app/app/presentation/screens/add_edit_user/add_edit_user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddEditUser();
              }));
            },
          )
        ],
        title: const Text("Users"),
      ),
      body: Container(
        child: ListView(
          children: List.generate(100, (index) {
            return HomeListItem(label: index.toString(), index: index);
          }),
        ),
      ),
    );
  }
}

class HomeListItem extends StatelessWidget {
  const HomeListItem({super.key, required this.label, required this.index});
  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => {print("User ${index + 1} clicked")},
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
                Text(
                  "User ${index + 1}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                print("User ${index + 1} delete called");
              },
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
