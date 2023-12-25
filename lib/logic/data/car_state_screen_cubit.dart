import 'package:flutter_bloc/flutter_bloc.dart';

part 'car_state_screen_state.dart';

class CarStateScreenCubit extends Cubit<CarStateScreenState> {
  CarStateScreenCubit() : super(InitialState()){
    getCarStatus();
  }

  void getCarStatus(){
    emit(LoadingState());
    Future.delayed(const Duration(seconds: 3));
    // TODO : backend
    emit(GotCarStatusState(enterParkingTime: "12:00 AM", enterLotTime: "12:05 AM", priceTillNow: "23000 تومان"));
  }

}
