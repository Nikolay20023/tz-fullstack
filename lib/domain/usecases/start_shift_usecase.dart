import '../entities/shift_entity.dart';
import '../repositories/shift_repository.dart';

class StartShiftUseCase {
  final ShiftRepository _shiftRepository;

  const StartShiftUseCase(this._shiftRepository);

  Future<ShiftEntity> call(String userId) async {
    return await _shiftRepository.startShift(userId);
  }
}
