import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  final auth = AuthRepository();

  Future<void> signUpWithEmail(
      {required String userEmail, required String userPassword}) async {
    if (userEmail == '') {
      print('AuthCubitERROR');
      emit(AuthErrorState(errorMessage: 'Email Cannot be empty'));
    } else if (userPassword.isEmpty) {
      emit(AuthErrorState(errorMessage: 'Password cannot be empty'));
    } else {
      try {
        print('AuthCubit1');
        await auth.signUp(userEmail, userPassword);
        emit(AuthLoadedState());
        print('AuthCubit2');
      } on Exception catch (e) {
        print('AuthCubit error $e');
        emit(AuthErrorState(errorMessage: '$e'));
      }
    }
  }

  Future<void> signInWithEmail(
      {required String userEmail, required String userPassword}) async {
    if (userEmail == '') {
      print('AuthCubitERROR signInWithEmail');
      emit(AuthErrorState(errorMessage: 'Email Cannot be empty'));
    } else if (userPassword.isEmpty) {
      emit(AuthErrorState(errorMessage: 'Password cannot be empty'));
    } else {
      try {
        await auth
            .signIn(userEmail, userPassword);
        print('signInWithEmail');
        emit(AuthLoadedState());
      } on Exception catch (e) {
        emit(AuthErrorState(errorMessage: '$e'));
        print('ERROR SIGN IN ${e.toString()}');
      }
    }
  }
}
