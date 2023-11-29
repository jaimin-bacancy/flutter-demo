import 'dart:async';

import 'package:awesome_app/app/data/models/user.dart';
import 'package:awesome_app/app/data/network/api_client.dart';
import 'package:awesome_app/app/data/riverpod/token_notifier.dart';
import 'package:awesome_app/app/data/riverpod/user_notifier.dart';
import 'package:awesome_app/app/presentation/screens/home/home_screen.dart';
import 'package:awesome_app/app/presentation/screens/register/register_screen.dart';
import 'package:awesome_app/app/presentation/widgets/form_button.dart';
import 'package:awesome_app/app/presentation/widgets/form_input.dart';
import 'package:awesome_app/base_configs/configs/string_config.dart';
import 'package:awesome_app/utils/common_methods.dart';
import 'package:awesome_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(StringConfig.loginText)),
        body: const LoginForm());
  }
}

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

void onSubmitPress(BuildContext context, String email, String password,
    WidgetRef ref, User? currentUser) {
  if (email.isEmpty || password.isEmpty) {
    CommonMethods.showAlert(context, StringConfig.emailPasswordCannotBeEmpty);
  } else if (Validation.validateEmail(email) != null) {
    CommonMethods.showAlert(context, Validation.validateEmail(email) ?? "");
  } else if (Validation.validatePassword(password) != null) {
    CommonMethods.showAlert(
        context, Validation.validatePassword(password) ?? "");
  } else {
    ApiClient(context).userLoginApi(email, password).then((value) {
      ref.read(tokenNotifierProvider.notifier).setAuthToken(value.data.token);
      ref.read(userNotifierProvider.notifier).setCurrentUser(value.data.user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }).onError((error, stackTrace) {
      CommonMethods.showAlert(context, (error.toString()));
    });
  }
}

class _LoginFormState extends ConsumerState<LoginForm> {
  String _email = "jaimin@gmail.com";
  String _password = "Jai@73min";

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.watch(userNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormInput(
          initialValue: _email,
          label: StringConfig.emailIdText,
          placeholderText: StringConfig.enterEmailText,
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.emailAddress,
          onChanged: (text) {
            _email = text;
          },
          validator: (value) {
            return Validation.validateEmail(value!);
          },
        ),
        const SizedBox(height: 12),
        FormInput(
          initialValue: _password,
          label: StringConfig.passwordText,
          placeholderText: StringConfig.enterPasswordText,
          obscureText: true,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          onChanged: (text) {
            _password = text;
          },
          validator: (value) {
            return Validation.validatePassword(value!);
          },
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Center(
                child: FormButton(
              label: StringConfig.submit,
              onButtonPress: () {
                onSubmitPress(context, _email, _password, ref, userNotifier);
              },
            )),
            const SizedBox(height: 12),
            const RegisterView()
          ],
        ),
      ]),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  void onRegisterPress(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          StringConfig.registerAccountText,
          style: TextStyle(fontSize: 14),
        ),
        InkWell(
            onTap: () => {onRegisterPress(context)},
            child: const Text(StringConfig.registerText,
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)))
      ],
    );
  }
}
