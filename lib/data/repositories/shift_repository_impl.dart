import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../datasources/supabase_remote_data_source.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final SupabaseRemoteDataSource _remoteDataSource;

  const ShiftRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ShiftEntity>> getUserShifts(String userId) async {
    final shiftModels = await _remoteDataSource.getUserShifts(userId);
    return shiftModels.map((model) => ShiftEntity(
      id: model.id,
      userId: model.userId,
      startTime: model.startTime,
      endTime: model.endTime,
      status: model.status,
    )).toList();
  }

  @override
  Future<ShiftEntity> startShift(String userId) async {
    final shiftModel = await _remoteDataSource.startShift(userId);
    return ShiftEntity(
      id: shiftModel.id,
      userId: shiftModel.userId,
      startTime: shiftModel.startTime,
      endTime: shiftModel.endTime,
      status: shiftModel.status,
    );
  }

  @override
  Future<ShiftEntity> endShift(String shiftId) async {
    final shiftModel = await _remoteDataSource.endShift(shiftId);
    return ShiftEntity(
      id: shiftModel.id,
      userId: shiftModel.userId,
      startTime: shiftModel.startTime,
      endTime: shiftModel.endTime,
      status: shiftModel.status,
    );
  }
}
