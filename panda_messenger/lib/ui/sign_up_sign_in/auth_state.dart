import 'package:equatable/equatable.dart';

class AuthStates extends Equatable {
  @override
  List<Object?> get props => [];

}

class AuthInitialState extends AuthStates {}

class AuthLoadedState extends AuthStates {
}

class AuthErrorState extends AuthStates {
  String errorMessage;

  AuthErrorState({
    required this.errorMessage
  });
  @override
  List<Object?> get props => [double.nan];
}