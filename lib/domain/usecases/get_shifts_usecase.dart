import '../entities/shift_entity.dart';
import '../repositories/shift_repository.dart';

class GetShiftsUseCase {
  final ShiftRepository _shiftRepository;

  const GetShiftsUseCase(this._shiftRepository);

  Future<List<ShiftEntity>> call(String userId) async {
    return await _shiftRepository.getUserShifts(userId);
  }
}
