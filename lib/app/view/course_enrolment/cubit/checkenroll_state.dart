part of 'checkenroll_cubit.dart';

@immutable
abstract class CheckenrollState {}

class CheckenrollInitial extends CheckenrollState {}
class CheckenrollChecking extends CheckenrollState {}
class CheckenrollEnrolled extends CheckenrollState {}
class CheckenrollUnenrol extends CheckenrollState {}
