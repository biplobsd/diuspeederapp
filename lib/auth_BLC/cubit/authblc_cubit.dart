import 'package:bloc/bloc.dart';
import 'package:diuspeeder/auth_BLC/blc_api.dart';
import 'package:diuspeeder/auth_BLC/model/user_data.dart';
import 'package:flutter/foundation.dart';

part 'authblc_state.dart';

class AuthblcCubit extends Cubit<AuthblcState> {
  AuthblcCubit() : super(AuthblcInitialState()) {
    _blClogin = BLCApi();
    isLogin();
  }

  late final BLCApi _blClogin;
  late UserData userData;

  Future<void> isLogin() async {
    emit(AuthblcLoadingState());
    await _blClogin.hiveInitial();
    final userData = _blClogin.userData;
    if (!userData.userid.isNegative) {
      emit(AuthblcLoginState());
      this.userData = userData;
    } else {
      emit(AuthblcLogoutState());
    }
  }

  Future<void> login({
    required String user,
    required String pass,
    required bool isSave,
  }) async {
    emit(AuthblcLoadingState());
    _blClogin.setUserpass(user, pass, isSave);

    if (await _blClogin.login()) {
      userData = await _blClogin.getUser();
      if (kDebugMode) {
        print('Success!');
      }
      emit(AuthblcLoginState());
    } else {
      emit(AuthblcErrorState());
    }
  }

  void testLogin() {
    _blClogin.apiAutoLogin();
  }

  void testWebLogin() {
    _blClogin.webLogin();
  }

  Future<bool> vplPosting(String pid, String filename, String data) async {
    var checkMethodInt = 0;
    var isLogin = true;

    while (!await _blClogin.isWebLoginSuccess()) {
      if (checkMethodInt >= 2) {
        isLogin = false;
        break;
      }
      switch (checkMethodInt) {
        case 0:
          await _blClogin.apiAutoLogin();
          checkMethodInt++;
          break;
        case 1:
          await _blClogin.webLogin();
          checkMethodInt++;
          break;
        default:
          if (kDebugMode) {
            print('Login failed');
          }
          emit(AuthblcErrorState());
      }
    }
    if (isLogin) {
      final result = await _blClogin.postVPL(
        pid: pid,
        filename: filename,
        data: data,
      );
      return result;
    }
    return false;
  }

  void logout() {
    _blClogin.logout();
    emit(AuthblcLogoutState());
  }
}
