import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_getx_sns_login/screens/profile_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class Authentication {
  static late LoginType _loginType;
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    await FirebaseAppCheck.instance
        .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var userInfo = user.providerData[0];
      userInfo.providerId == 'facebook.com'
          ? _loginType = LoginType.Facebook
          : _loginType = LoginType.Google;
      Get.off(
        () => ProfileScreen(),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithFacebook() async {
    _loginType = LoginType.Facebook;
    final LoginResult result = await FacebookAuth.instance.login();

    final AccessToken accessToken = result.accessToken!;

    final facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.token);

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    final User? user = userCredential.user;

    if (user != null && userCredential.additionalUserInfo!.isNewUser) {
      // FirebaseRepository.createUser(user.uid.toString(), user.email.toString(),
      //     user.displayName.toString(), user.photoURL.toString());
    }

    return user;
  }

  static Future<void> signOutWithFacebook(
      {required BuildContext context}) async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<User?> signInWithGoogle() async {
    _loginType = LoginType.Google;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;

        if (user != null && userCredential.additionalUserInfo!.isNewUser) {
          // FirebaseRepository.createUser(
          //     user.uid.toString(),
          //     user.email.toString(),
          //     user.displayName.toString(),
          //     user.photoURL.toString());
        }
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;

        if (user != null && userCredential.additionalUserInfo!.isNewUser) {
          // FirebaseRepository.createUser(
          //     user.uid.toString(),
          //     user.email.toString(),
          //     user.displayName.toString(),
          //     user.photoURL.toString());
        }
      }
      return user;
    }
  }

  static Future<void> signOutWithGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}

enum LoginType { Email, Google, Facebook, Kakao, Naver }
