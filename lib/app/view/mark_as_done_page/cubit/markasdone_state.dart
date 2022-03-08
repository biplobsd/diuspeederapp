part of 'markasdone_cubit.dart';

@immutable
abstract class MarkasdoneState {}

class MarkasdoneGettingDataState extends MarkasdoneState {}
class MarkasdoneGettingButtonsState extends MarkasdoneState {}
class MarkasdoneLoadingState extends MarkasdoneState {}
class MarkasdoneIdealState extends MarkasdoneState {}

