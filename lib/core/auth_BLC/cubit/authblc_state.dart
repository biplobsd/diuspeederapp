part of 'authblc_cubit.dart';

@immutable
abstract class AuthblcState {}

class AuthblcInitialState extends AuthblcState {}

class AuthblcLoginState extends AuthblcState {}

class AuthblcLogoutState extends AuthblcState {}

class AuthblcLoadingState extends AuthblcState {}

class AuthblcErrorState extends AuthblcState {}
