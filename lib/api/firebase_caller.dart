import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCaller {
  FirebaseCaller._();
  static Future<bool> writeEmail({required String email}) async {
    if (!await checkUser(email: email)) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword',
      );
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword',
      );
    }
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      return false;
    } else {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      return true;
    }
  }

  static Future<bool> checkUser({required String email}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: "temporaryPassword");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      } else {
        return false;
      }
    }
  }

  static Future<bool> unsubcribe({required String email}) async {
    if (await checkUser(email: email)) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword',
      );
      await FirebaseAuth.instance.currentUser!.delete();
      return true;
    } else {
      return false;
    }
  }
}
