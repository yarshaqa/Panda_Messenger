import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panda_messenger/internet_connection.dart';
import 'package:panda_messenger/user_repository.dart';

import '../../auth_repository.dart';
import '../../models/message_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState()) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none){
        emit(HomeErrorState(errorMessage: 'Network problem!'));
      }
    });
  }

  NetworkConnectivity connectivity = NetworkConnectivity.instance;
  final auth = AuthRepository();

  void messagesStream() async {
    print('auth.getLoggedUserId ${auth.getLoggedUserId}');
    final messages = auth.firebaseDataProvider
        .getAllChatMessagesStream(auth.getLoggedUserId)
        .listen((event) {});
    messages.onData((data) {
      if (data.isNotEmpty) {
        emit(HomeLoadedState(messagesList: data));
        print('data.last.message ${data[0].message!}');
      } else {
        emit(HomeInitialState());
      }
    });
  }

  void sendMessage(MessageModel messageModel) async {
    try {
      messageModel.chatId = auth.getLoggedUserId;
      messageModel.senderName = UserRepository.userRepository.getUserEmail;
      auth.firebaseDataProvider.sendMessageToPal(messageModel);
    } on SocketException {
      emit(HomeErrorState(errorMessage: 'Network problem!'));
    }
  }

  void logOutUser() async {
    auth.logOut();
    emit(HomeLogOutState());
  }
}
