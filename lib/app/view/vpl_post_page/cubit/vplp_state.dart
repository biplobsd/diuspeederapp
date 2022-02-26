part of 'vplp_cubit.dart';

@immutable
abstract class VplpState {}

class VplpInitialState extends VplpState {}

class VplpostSuccessState extends VplpState {}

class VplpostunsuccessState extends VplpState {}

class VplpostPageIdEmptyState extends VplpState {}

class VplpostCodeFieldEmptyState extends VplpState {}

class VplpLoadingState extends VplpState {}
