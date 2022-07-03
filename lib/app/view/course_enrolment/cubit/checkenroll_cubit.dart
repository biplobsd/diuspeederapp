import 'package:bloc/bloc.dart';
import 'package:diuspeeder/core/auth_BLC/cubit/authblc_cubit.dart';
import 'package:meta/meta.dart';

part 'checkenroll_state.dart';

class CheckenrollCubit extends Cubit<CheckenrollState> {
  CheckenrollCubit({required this.authblcCubit}) : super(CheckenrollInitial());

  AuthblcCubit authblcCubit;

  void checking() {}
}
