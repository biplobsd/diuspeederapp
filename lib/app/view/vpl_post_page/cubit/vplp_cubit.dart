import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vplp_state.dart';

class VplpCubit extends Cubit<VplpState> {
  VplpCubit() : super(VplpInitialState());

  void setLoadingState() {
    emit(VplpLoadingState());
  }

  void postSuccess({required bool result}) {
    if (result) {
      emit(VplpostSuccessState());
    } else {
      emit(VplpostunsuccessState());
    }
  }

  void setErrorPageId (VplpState error) {
    emit(error);
  
  }
}
