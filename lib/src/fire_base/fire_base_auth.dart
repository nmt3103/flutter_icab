import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserInRealtime({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    final String userId = user!.uid;
    var userIn = {
      "name": fullName,
      "phone": phone,
      "email": email,
      "password": password,
    };
    await FirebaseDatabase.instance.ref("users").child(userId).set(userIn);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
