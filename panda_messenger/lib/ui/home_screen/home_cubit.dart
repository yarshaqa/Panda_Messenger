import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panda_messenger/internet_connection.dart';
import 'package:panda_messenger/user_repository.dart';

import '../../auth_repository.dart';
import '../../models/message_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {

  final AuthRepository authRepository;
  HomeCubit({required this.authRepository}) : super(HomeInitialState()) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none){
        emit(HomeErrorState(errorMessage: 'Network problem!'));
      }
    });
  }

  NetworkConnectivity connectivity = NetworkConnectivity.instance;
   List<MessageModel> allMessages = [];
  void messagesStream(String searchField) async {
    print('auth.getLoggedUserId ${authRepository.getLoggedUserId}');
    final messages = authRepository.firebaseDataProvider
        .getAllChatMessagesStream(authRepository.getLoggedUserId)
        .listen((event) {});
    messages.onData((data) {
      if (data.isNotEmpty) {
        allMessages = data;
        emit(HomeLoadedState(messagesList: data));
        print('data.last.message ${data[0].message!}');
      }
     else {
        emit(HomeInitialState());
      }
    });
  }

  void findMessage(String searchField) {
      List<MessageModel> foundMessages = [];
      for(MessageModel i in allMessages){
        if (i.message!.contains(searchField)){
          foundMessages.add(i);
        };
      }
      print('lol');
      emit(HomeLoadedState(messagesList: foundMessages));
    }

  void sendMessage(MessageModel messageModel) async {
    try {
      messageModel.chatId = authRepository.getLoggedUserId;
      messageModel.senderName = UserRepository.userRepository.getUserEmail;
      authRepository.firebaseDataProvider.sendMessageToPal(messageModel);
    } on SocketException {
      emit(HomeErrorState(errorMessage: 'Network problem!'));
    }
  }

  void logOutUser() async {
    authRepository.logOut();
    emit(HomeLogOutState());
  }
}
