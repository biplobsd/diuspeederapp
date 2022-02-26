import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loginpage_state.dart';

class LoginpageCubit extends Cubit<LoginpageState> {
  LoginpageCubit() : super(LoginpageInitialState());

  void errorMsg(String user, String pass) {
    if (user.isEmpty) {
      emit(LoginpageErrorState(msg: 'Username is required'));
    } else if (pass.isEmpty) {
      emit(LoginpageErrorState(msg: 'Password is required'));
    } else {
      emit(LoginpageNoErrorState());
    }
  }

  void saveData({required bool? isCheck}) {
    if (isCheck!) {
      emit(LoginpageSaveDataState());
    } else {
      emit(LoginpageDontSaveDataState());
    }
  }
}
