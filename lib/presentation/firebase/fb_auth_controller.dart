import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_response.dart';

class FbAuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseResponse> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      String message = userCredential.user!.emailVerified
          ? 'Logged in successfully'
          : 'Login failed!, activate your email';
      return FirebaseResponse(
          success: userCredential.user!.emailVerified, message: message);
    } on FirebaseAuthException catch (authException) {
      return FirebaseResponse(
          success: false, message: authException.message ?? '');
    }
  }

  void _controlException({required FirebaseAuthException authException}) async {
    if (authException.code == 'invalid-email') {
      //
    } else if (authException.code == 'user-disabled') {
      //
    } else if (authException.code == 'user-not-found') {
      //
    } else if (authException.code == 'wrong-password') {
      //
    }
  }

  Future<FirebaseResponse> createAccount(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      await _firebaseAuth.signOut();
      return FirebaseResponse(
          success: true,
          message: 'Account created successfully, activate to start');
    } on FirebaseAuthException catch (authException) {
      return FirebaseResponse(
          success: false, message: authException.message ?? '');
    }
  }

  Future<FirebaseResponse> sendPasswordResetEmail(
      {required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return FirebaseResponse(
          success: true, message: 'Password reset email sent!');
    } on FirebaseAuthException catch (authException) {
      return FirebaseResponse(
          success: false, message: authException.message ?? '');
    }
  }

  Future<void> signOut() async => _firebaseAuth.signOut();

  User get user => _firebaseAuth.currentUser!;

  bool get signedIn => _firebaseAuth.currentUser != null;
}
