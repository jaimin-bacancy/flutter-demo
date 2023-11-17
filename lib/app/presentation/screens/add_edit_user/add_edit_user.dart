import 'package:awesome_app/app/data/models/user.dart';
import 'package:awesome_app/app/data/network/api_client.dart';
import 'package:awesome_app/app/presentation/widgets/form_button.dart';
import 'package:awesome_app/app/presentation/widgets/form_date_picker.dart';
import 'package:awesome_app/app/presentation/widgets/form_input.dart';
import 'package:awesome_app/app/presentation/widgets/user_image.dart';
import 'package:awesome_app/base_configs/configs/string_config.dart';
import 'package:awesome_app/utils/common_methods.dart';
import 'package:awesome_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditUser extends StatelessWidget {
  User? user;
  AddEditUser({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(user != null
                ? StringConfig.editUserText
                : StringConfig.addUserText)),
        body: AddEditUserForm(user: user));
  }
}

class AddEditUserForm extends StatefulWidget {
  User? user;
  AddEditUserForm({super.key, this.user});

  @override
  State<AddEditUserForm> createState() => _AddEditUserFormState();
}

class _AddEditUserFormState extends State<AddEditUserForm> {
  String _name = "";
  String _email = "";
  XFile? _profileImage;
  IconData _icon = Icons.add_a_photo;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    _name = widget.user?.name ?? "";
    _email = widget.user?.email ?? "";
    super.initState();
  }

  void onSubmitPress(context) {
    if (_name.isEmpty) {
      CommonMethods.showAlert(context, StringConfig.pleaseEnterName);
    } else if (Validation.validateEmail(_email) != null) {
      CommonMethods.showAlert(context, Validation.validateEmail(_email) ?? "");
    } else {
      if (widget.user != null) {
        ApiClient()
            .updateMyUserApi((widget.user?.id ?? ""), _name, _email)
            .then((value) {
          Navigator.pop(context, true);
          CommonMethods.showAlert(context, value.message);
        }).onError((error, stackTrace) {
          CommonMethods.showAlert(context, (error.toString()));
        });
      } else {
        ApiClient().addMyUserApi(_name, _email).then((value) {
          Navigator.pop(context, true);
          CommonMethods.showAlert(context, value.message);
        }).onError((error, stackTrace) {
          CommonMethods.showAlert(context, (error.toString()));
        });
      }
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

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1947),
          lastDate: DateTime.now());

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    return Container(
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
        FormDatePicker(
          label: StringConfig.selectDobText,
          selectDate: _selectDate,
          selectedDate: selectedDate,
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
          ],
        ),
      ]),
    );
  }
}
