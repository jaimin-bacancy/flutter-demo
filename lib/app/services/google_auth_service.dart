import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn(
      clientId:
          '966535779882-u0jpg4pqnfbj09rap788v5fq8u1gkmdb.apps.googleusercontent.com',
    ).signIn();

    GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // final credential = GoogleAuthProvider.credential(
    //     accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    return gAuth;
  }
}
