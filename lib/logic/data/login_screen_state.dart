part of 'login_screen_cubit.dart';

abstract class LoginScreenState {}

class InitialState extends LoginScreenState {}

class LoadingState extends LoginScreenState {}

class LoginSuccessState extends LoginScreenState {}

class SignUpSuccessState extends LoginScreenState {}

class FailedState extends LoginScreenState {
  final String message;

  FailedState(this.message);
}

class ToggledModeState extends LoginScreenState {}

class ShowHeaderState extends LoginScreenState {}
