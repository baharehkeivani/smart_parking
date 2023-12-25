import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_parking/logic/model/lot_model.dart';
import 'package:smart_parking/logic/model/user_model.dart';
import 'package:smart_parking/module/constants.dart';

part 'login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  LoginScreenCubit() : super(InitialState());

  Future<void> login({required String id,required String password}) async {
    emit(LoadingState());

    // TODO call api

    //success
    Constants.instance.userModel = UserModel(name: "بهاره",
        familyName: "کیوانی",
        profileImage: "",
        id: "0925657832",
        carSpace: LotModel(x: 0,y: 4,status: LotStatus.occupied));
    emit(LoginSuccessState());

    // fail
    // emit(LoginFailedState("مشکلی هنگام ورود رخ داده است. لطفا دوباره امتحان کنید. "));
  }
  Future<void> signup({required String id,required String password,required String name,required String familyName,required String carId,String? carType}) async {
    emit(LoadingState());

    // TODO call api

    //success
    Constants.instance.userModel = UserModel(name: "بهاره",
        familyName: "کیوانی",
        profileImage: "",
        id: "0925657832",
        carSpace: LotModel(x: 0,y: 5,status: LotStatus.occupied));
    emit(SignUpSuccessState());

    // fail
    // emit(LoginFailedState("مشکلی هنگام ورود رخ داده است. لطفا دوباره امتحان کنید. "));
  }

  void toggleMode(){
    emit(ToggledModeState());
  }
  void showHeader(){
    emit(ShowHeaderState());
  }

}
