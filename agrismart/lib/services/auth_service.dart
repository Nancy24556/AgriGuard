import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return userCredential;
  }

  Future<UserCredential> signIn({
  required String email,
  required String password,
  }) async {
  try {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        throw Exception("Aucun compte trouvé avec cette adresse e-mail.");

      case 'wrong-password':
      case 'invalid-credential':
        throw Exception("Adresse e-mail ou mot de passe incorrect.");

      case 'invalid-email':
        throw Exception("L'adresse e-mail est invalide.");

      case 'network-request-failed':
        throw Exception("Vérifiez votre connexion Internet.");

      default:
        throw Exception("Erreur de connexion : ${e.message}");
    }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}