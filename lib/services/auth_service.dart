import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      return credential.user;
    } catch (e) {
      print('Error in anonymous sign-in: $e');
      return null;
    }
  }

  static Future<User?> signInWithEmail(
      String email,
      String password,
      ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Error in email sign-in: $e');
      return null;
    }
  }

  static User? get currentUser => _auth.currentUser;

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
