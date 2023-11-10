import 'package:flutter/material.dart';

class AddEditUser extends StatelessWidget {
  const AddEditUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add User")),
      body: Container(
        child: const Text("Add User"),
      ),
    );
  }
}
