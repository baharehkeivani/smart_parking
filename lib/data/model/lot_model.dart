enum LotStatus {
  occupied, free , reserved
}

class LotModel {
  final int x;
  final int y;
  final LotStatus status;

  LotModel(this.x, this.y, this.status);
}