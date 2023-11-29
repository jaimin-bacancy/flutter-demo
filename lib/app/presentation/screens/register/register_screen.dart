import 'package:awesome_app/app/data/network/api_client.dart';
import 'package:awesome_app/app/presentation/widgets/form_button.dart';
import 'package:awesome_app/app/presentation/widgets/form_input.dart';
import 'package:awesome_app/app/presentation/widgets/user_image.dart';
import 'package:awesome_app/base_configs/configs/string_config.dart';
import 'package:awesome_app/utils/common_methods.dart';
import 'package:awesome_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text(StringConfig.registerText)),
        body: const RegisterForm());
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String _name = "";
  String _email = "";
  String _password = "";
  XFile? _profileImage;
  IconData _icon = Icons.add_a_photo;

  void onSubmitPress(context) {
    if (_email.isEmpty || _password.isEmpty || _name.isEmpty) {
      CommonMethods.showAlert(
          context, StringConfig.nameEmailPasswordCannotBeEmpty);
    } else if (Validation.validateEmail(_email) != null) {
      CommonMethods.showAlert(context, Validation.validateEmail(_email) ?? "");
    } else if (Validation.validatePassword(_password) != null) {
      CommonMethods.showAlert(
          context, Validation.validatePassword(_password) ?? "");
    } else {
      ApiClient(context)
          .userRegisterApi(_name, _email, _password)
          .then((value) {
        Navigator.pop(context);
        CommonMethods.showAlert(context, value.message);
      }).onError((error, stackTrace) {
        CommonMethods.showAlert(context, (error.toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void handleImageSelect() async {
      final ImagePicker picker = ImagePicker();
      _profileImage = await picker.pickImage(source: ImageSource.gallery);
      if (_profileImage != null) {
        _icon = Icons.edit;
      }
      setState(() {});
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UserImage(
            image: _profileImage,
            onImageSelect: handleImageSelect,
            icon: _icon,
          ),
          const SizedBox(height: 12),
          FormInput(
            initialValue: _name,
            label: StringConfig.nameText,
            placeholderText: StringConfig.enterNameText,
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.emailAddress,
            onChanged: (text) {
              _name = text;
            },
          ),
          const SizedBox(height: 12),
          FormInput(
            initialValue: _email,
            label: StringConfig.emailIdText,
            placeholderText: StringConfig.enterEmailText,
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.emailAddress,
            onChanged: (text) {
              _email = text;
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
      ),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  void onLoginPress(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          StringConfig.alreadyUserText,
          style: TextStyle(fontSize: 14),
        ),
        InkWell(
            onTap: () {
              onLoginPress(context);
            },
            child: const Text(StringConfig.loginText,
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
