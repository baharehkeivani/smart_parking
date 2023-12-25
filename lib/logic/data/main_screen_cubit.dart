import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_parking/module/constants.dart';

import '../model/lot_model.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(InitialState()) {
    _initializeSpaces();
  }

  List<LotModel> lots = [];

  final int _numberOfLots = 12;
  final int numberOfColumns = 2;
  late int carsEachColumn ;

  void _initializeSpaces() {
    carsEachColumn = _numberOfLots ~/ numberOfColumns;
    lots = List.generate(
        _numberOfLots,
        (index) =>
            LotModel(x: index ~/ carsEachColumn, y: index % carsEachColumn));

    lots[2].status = LotStatus.occupied;
    lots[9].status = LotStatus.reserved;
    lots[0].status = LotStatus.reserved;
  }

  void getSpacesStatus() {
    // TODO : backend
    // must be updated each
    lots[4].status = LotStatus.occupied;
    emit(UpdateSuccessState());
  }

  void updateNow(){
    emit(UpdateNowState());
  }

  void logout(){
    // TODO : backend
    // TODO : empty hive
    Constants.instance.userModel = null;
    emit(LogoutState());
  }
}
