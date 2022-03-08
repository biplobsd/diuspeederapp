import 'package:bloc/bloc.dart';
import 'package:diuspeeder/core/auth_BLC/blc_api.dart';
import 'package:diuspeeder/core/auth_BLC/model/user_data.dart';
import 'package:flutter/foundation.dart';

part 'authblc_state.dart';

class AuthblcCubit extends Cubit<AuthblcState> {
  AuthblcCubit() : super(AuthblcInitialState()) {
    _blClogin = BLCApi();
    isLogin();
  }

  late final BLCApi _blClogin;
  late UserData userData;

  BLCApi get blcApi => _blClogin;

  Future<void> isLogin() async {
    emit(AuthblcLoadingState());
    await _blClogin.hiveInitial();
    final userData = _blClogin.userData;
    if (!userData.userid.isNegative) {
      this.userData = userData;
      emit(AuthblcLoginState());
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
    if (await _blClogin.webAccess()) {
      final result = await _blClogin.postVPL(
        pid: pid,
        filename: filename,
        data: data,
      );
      return result;
    }
    emit(AuthblcErrorState());
    return false;
  }

  void logout() {
    _blClogin.logout();
    emit(AuthblcLogoutState());
  }
}
