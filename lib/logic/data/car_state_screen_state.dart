part of 'car_state_screen_cubit.dart';

abstract class CarStateScreenState {}

class InitialState extends CarStateScreenState {}

class LoadingState extends CarStateScreenState {}

class GotCarStatusState extends CarStateScreenState {
  final String enterParkingTime;
  final String enterLotTime;
  final String priceTillNow;

  GotCarStatusState({
    required this.enterParkingTime,
    required this.enterLotTime,
    required this.priceTillNow,
  });
}
