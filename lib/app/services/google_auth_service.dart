import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn(
      clientId: dotenv.env['GOOGLE_CLIENT_ID'],
    ).signIn();

    GoogleSignInAuthentication gAuth = await gUser!.authentication;

    return gAuth;
  }
}
