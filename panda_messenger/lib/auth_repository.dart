import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_data_provider.dart';

class AuthRepository {

  FirebaseDataProvider firebaseDataProvider =
      FirebaseDataProvider(firestore: FirebaseFirestore.instance);

  final FirebaseAuth auth = FirebaseAuth.instance;

  get getLoggedUserId => auth.currentUser!.uid;

  Future<void> signUp(userEmail, userPassword) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      firebaseDataProvider.createUser(
          auth.currentUser!, DateTime.now().toString(), userEmail);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException SignUp $e');
      throw Exception(e.message);
    }
  }

  Future signIn(userEmail, userPassword) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      await firebaseDataProvider.loginUser();
    } on FirebaseAuthException catch (e) {
      print('userPassword: $userPassword');
      print('FirebaseAuthException SignIn $e');
      throw Exception(e.message);
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException SignIn $e');
      throw Exception(e.message);
    }
  }
}
