
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ngdemo14/pages/signin_page.dart';
import 'package:ngdemo14/services/log_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static bool isLoggedIn() {
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser != null;
  }

  static String currentUserId() {
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser!.uid;
  }

  static Future<User?> signInUser(
      BuildContext context, String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      LogService.i(credential.toString());

      User? user = _auth.currentUser;
      LogService.i(user.toString());
      return user;
    } on FirebaseAuthException catch (e) {
      LogService.e(e.toString());
      return null;
    }
  }

  static Future<User?> signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      LogService.i(user.toString());

      return user;
    } on FirebaseAuthException catch (e) {
      LogService.e(e.toString());
      return null;
    }
  }

  static void signOutUser(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, SignInPage.id);
    //await Prefs.removeUserId();
  }
}
