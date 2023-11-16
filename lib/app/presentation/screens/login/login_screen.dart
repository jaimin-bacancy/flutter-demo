import 'dart:async';

import 'package:awesome_app/app/data/network/api_client.dart';
import 'package:awesome_app/app/presentation/screens/home/home_screen.dart';
import 'package:awesome_app/app/presentation/screens/register/register_screen.dart';
import 'package:awesome_app/app/presentation/widgets/form_button.dart';
import 'package:awesome_app/app/presentation/widgets/form_input.dart';
import 'package:awesome_app/base_configs/configs/string_config.dart';
import 'package:awesome_app/utils/common_methods.dart';
import 'package:awesome_app/utils/shared_pref_utils.dart';
import 'package:awesome_app/utils/validation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(StringConfig.loginText)),
        body: const LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email = "";
  String _password = "";

  void onSubmitPress(context) {
    if (_email.isEmpty || _password.isEmpty) {
      CommonMethods.showAlert(context, StringConfig.emailPasswordCannotBeEmpty);
    } else if (Validation.validateEmail(_email) != null) {
      CommonMethods.showAlert(context, Validation.validateEmail(_email) ?? "");
    } else if (Validation.validatePassword(_password) != null) {
      CommonMethods.showAlert(
          context, Validation.validatePassword(_password) ?? "");
    } else {
      ApiClient().userLoginApi(_email, _password).then((value) {
        SharedPrefUtils().setUserToken(value.data.token);
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

  @override
  Widget build(BuildContext context) {
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
                onSubmitPress(context);
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
