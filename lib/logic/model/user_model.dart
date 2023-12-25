import 'package:hive/hive.dart';

import 'lot_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject{
  UserModel({
    this.name,
    this.familyName,
    this.id,
    this.profileImage,
    this.carSpace,
    this.carID,
    this.carType,
  });

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? familyName;

  @HiveField(2)
  String? id; // unique national id of car's owner

  @HiveField(3)
  String? profileImage;

  @HiveField(4)
  LotModel? carSpace;

  @HiveField(5)
  String? carType;

  @HiveField(6)
  String? carID;
}
