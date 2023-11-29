// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_app/app/data/riverpod/token_notifier.dart';
import 'package:awesome_app/app/presentation/screens/home/home_screen.dart';
import 'package:awesome_app/app/presentation/screens/login/login_screen.dart';
import 'package:awesome_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  void isAuthTokenExist() async {
    Timer(const Duration(seconds: 2), () async {
      String? token = ref.read(tokenNotifierProvider.notifier).getAuthToken();

      if (Validation.validateEmptyField(value: (token ?? "")) == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isAuthTokenExist();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.amber)));
  }
}
