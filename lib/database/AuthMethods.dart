import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  Future<String> createAccount(
      {required String name,
      required String email,
      required String pwd}) async {
    String res = "error";
    if (email.isNotEmpty || pwd.isNotEmpty) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
      res = "Success";
    }
    return res;
  }

  Future<String> logIn({required email, required pwd}) async {
    String res = "error";
    if (email.isNotEmpty || pwd.isNotEmpty) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      res = "success";
    }
    return res;
  }
}
