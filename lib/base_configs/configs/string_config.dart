abstract class StringConfig {
  StringConfig._();

  //Login Screen
  static const String loginText = 'Login';
  static const String emailIdText = 'Email ID';
  static const String enterEmailText = 'Enter email ID';
  static const String passwordText = 'Password';
  static const String enterPasswordText = 'Enter Password';
  static const String submit = 'Submit';
  static const String registerAccountText = "New to Awesome App? ";
  static const String registerText = 'Register';

  //Register Screen
  static const String nameText = 'Name';
  static const String enterNameText = 'Enter name';
  static const String alreadyUserText = "Already a user? ";

  //Users Screen
  static const String usersText = 'Users';
  static const String searchUserText = "Search user...";

  //Add User Screen
  static const String addUserText = "Add User";
  static const String selectDobText = "Select DOB";

  //Edit User Screen
  static const String editUserText = "Edit User";

  // Field validations
  static const String fieldCannotBeEmpty = 'This field cann\'t be empty';
  static const String pleaseEnterPassword = 'Please enter password';
  static const String pleaseEnterName = 'Please enter name';
  static const String passwordLengthError =
      'The password must be at least 8 characters';
  static const String specialCharValidation =
      'Password must contain at least one number and both uppercase and lowercase letters.';
  static const String pleaseProvideValidEmail = 'Please provide valid Email ID';
  static const String pleaseEnterEmail = 'Please enter Email ID';
  static const String pleaseSelectDOB = 'Please select DOB';
  static const String emailPasswordCannotBeEmpty =
      "Email/Password cannot be empty";
  static const String nameEmailPasswordCannotBeEmpty =
      "Name/Email/Password cannot be empty";
}
