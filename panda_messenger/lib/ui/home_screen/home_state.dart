import 'package:equatable/equatable.dart';

import '../../models/message_model.dart';

class HomeStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeStates {}

class HomeLoadedState extends HomeStates {
  HomeLoadedState({required this.messagesList});
  List<MessageModel> messagesList = [];
  @override
  List<Object?> get props => [messagesList];

}
class HomeLogOutState extends HomeStates {}

class HomeErrorState extends HomeStates {}
