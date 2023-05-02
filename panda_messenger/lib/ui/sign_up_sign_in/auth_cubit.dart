import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panda_messenger/internet_connection.dart';

import '../../auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState()) {
    NetworkConnectivity.instance.myStream.listen((event) async {
      String stringEvent = event.toString();
      if (stringEvent == '{ConnectivityResult.none: false}') {
        emit(AuthErrorState(errorMessage: 'Network problem'));
      }
    });
  }

  final auth = AuthRepository();

  Future<void> signUpWithEmail(
      {required String userEmail, required String userPassword}) async {
    if (userEmail == '') {
      emit(AuthErrorState(errorMessage: 'Email Cannot be empty'));
    } else if (userPassword.isEmpty) {
      emit(AuthErrorState(errorMessage: 'Password cannot be empty'));
    } else {
      try {
        await auth.signUp(userEmail, userPassword);
        emit(AuthLoadedState());
      } on Exception catch (e) {
        emit(AuthErrorState(errorMessage: '$e'));
      }
    }
  }

  Future<void> signInWithEmail(
      {required String userEmail, required String userPassword}) async {
    if (userEmail == '') {
      emit(AuthErrorState(errorMessage: 'Email Cannot be empty'));
    } else if (userPassword.isEmpty) {
      emit(AuthErrorState(errorMessage: 'Password cannot be empty'));
    } else {
      try {
        await auth.signIn(userEmail, userPassword);
        emit(AuthLoadedState());
        emit(AuthInitialState());
      } on Exception catch (e) {
        emit(AuthErrorState(errorMessage: '$e'));
      }
    }
  }
}
