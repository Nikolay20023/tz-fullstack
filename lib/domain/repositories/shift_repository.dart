import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  Future<List<ShiftEntity>> getUserShifts(String userId);
  Future<ShiftEntity> startShift(String userId);
  Future<ShiftEntity> endShift(String shiftId);
}
