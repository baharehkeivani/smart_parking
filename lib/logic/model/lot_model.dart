enum LotStatus { occupied, free, reserved }

class LotModel {
  LotModel({
    required this.x,
    required this.y,
    this.status = LotStatus.free,
  });

  final int x;
  final int y;
  LotStatus status;
}
