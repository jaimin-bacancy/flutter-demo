import 'package:awesome_app/app/presentation/screens/startup/startup_screen.dart';
import 'package:awesome_app/utils/shared_pref_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
  SharedPrefUtils().init();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const StartupScreen(),
    );
  }
}
