import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _onAuthStateChanged(user);
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;
  bool get isSignedIn => (user != null);

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final userCredentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredentials.user;
      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
