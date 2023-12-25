import 'lot_model.dart';

class UserModel {
  UserModel({
    this.name,
    this.familyName,
    this.id,
    this.profileImage,
    this.carSpace,
    this.carID,
    this.carType,
  });

  String? name;
  String? familyName;
  String? id; // unique national id of car's owner
  String? profileImage;
  LotModel? carSpace;
  String? carType;
  String? carID; // pelak
}
