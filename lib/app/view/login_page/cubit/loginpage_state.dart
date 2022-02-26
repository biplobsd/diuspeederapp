part of 'loginpage_cubit.dart';

@immutable
abstract class LoginpageState {}

class LoginpageInitialState extends LoginpageState {}

class LoginpageErrorState extends LoginpageState {
  LoginpageErrorState({
    required this.msg,
  });
  final String msg;
}


class LoginpageNoErrorState extends LoginpageState {}
