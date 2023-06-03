import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panda_messenger/user_repository.dart';

import 'models/message_model.dart';
import 'models/user_model.dart';

class FirebaseDataProvider {
  final FirebaseFirestore firestore;
  UserModel userModel = UserModel();
  MessageModel? messageModel;
  UserModel loggedUser = UserModel();
  Connectivity connectivity = Connectivity();

  static final FirebaseDataProvider firebaseDataProvider =
      FirebaseDataProvider._internal(FirebaseFirestore.instance);

  factory FirebaseDataProvider({required FirebaseFirestore firestore}) {
    return firebaseDataProvider;
  }

  FirebaseDataProvider._internal(this.firestore);

  Future<void> createUser(
    User user,
    String joinDate,
    String email,
  ) async {
    userModel.id = user.uid;
    userModel.email = email;
    userModel.joinDate = joinDate;
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore()).whenComplete(() => UserRepository.userRepository.userLoginRepo());
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: e.plugin, message: e.message);
    }
  }

  Future<void> loginUser() async {
    try {
      await UserRepository.userRepository.userLoginRepo();
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: e.plugin, message: e.message);
    }
  }

  Stream<List<MessageModel>> getAllChatMessagesStream(String chatId) {
    return firestore
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> sendMessageToPal(MessageModel messageModel) async {
    DateTime dateTimeNow = DateTime.now();
    try {
      final String messageId = firestore.collection('messages').doc().id;
      messageModel.messageId = messageId;
      messageModel.time = dateTimeNow.toString();
      await firestore
          .collection('messages')
          .doc(messageId)
          .set(messageModel.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message!);
    }
  }
}
