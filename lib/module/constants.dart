

import '../logic/model/lot_model.dart';
import '../logic/model/user_model.dart';

class Constants {
  Constants._();

  static final Constants _instance = Constants._();

  static Constants get instance => _instance;

  UserModel? userModel;

  Map<LotStatus, String> lotStates = {
    LotStatus.free: "آزاد",
    LotStatus.reserved: "رزرو شده",
    LotStatus.occupied: "پر شده",
  };
}
