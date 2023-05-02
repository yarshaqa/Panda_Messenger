import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panda_messenger/auth_repository.dart';

import 'models/user_model.dart';

class UserRepository {
  final auth = AuthRepository();

  static final UserRepository userRepository = UserRepository._internal();

  factory UserRepository() {
    return userRepository;
  }

  UserRepository._internal();

  UserModel loggedUser = UserModel();

  get getUserEmail {
    return loggedUser.email;
  }

  get getLoggedUser {
    return loggedUser;
  }

  Future<void> userLoginRepo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.auth.currentUser!.uid)
        .get()
        .then((value) => loggedUser = UserModel.fromJson(value.data()!));
  }
}
