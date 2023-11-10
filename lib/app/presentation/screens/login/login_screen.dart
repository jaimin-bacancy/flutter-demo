import 'package:awesome_app/app/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: const LoginForm());
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child:
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FormInput(
          label: "Email",
          placeholderText: "Enter email address",
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.emailAddress,
        ),
        SizedBox(height: 12),
        FormInput(
          label: "Password",
          placeholderText: "Enter password",
          obscureText: true,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
        ),
        SizedBox(height: 12),
        Center(child: FormButton()),
      ]),
    );
  }
}

class FormInput extends StatefulWidget {
  final String label;
  final String placeholderText;
  final bool? obscureText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  const FormInput(
      {super.key,
      required this.label,
      required this.placeholderText,
      this.obscureText,
      this.textInputAction,
      this.textInputType});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        TextField(
          onChanged: (text) {
            _value = text;
          },
          obscureText: widget.obscureText ?? false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.placeholderText,
          ),
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          keyboardType: widget.textInputType ?? TextInputType.text,
        ),
      ],
    );
  }
}

class FormButton extends StatelessWidget {
  const FormButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(42),
      ),
      onPressed: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }))
      },
      child: const Text("Submit"),
    );
  }
}
