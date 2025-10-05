import '../entities/shift_entity.dart';
import '../repositories/shift_repository.dart';

class EndShiftUseCase {
  final ShiftRepository _shiftRepository;

  const EndShiftUseCase(this._shiftRepository);

  Future<ShiftEntity> call(String shiftId) async {
    return await _shiftRepository.endShift(shiftId);
  }
}
