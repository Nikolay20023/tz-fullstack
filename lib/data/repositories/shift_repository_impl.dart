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
      profileId: model.profileId,
      startTime: model.startTime,
      endTime: model.endTime,
      status: model.status,
      description: model.description,
      hourlyRate: model.hourlyRate,
      totalHours: model.totalHours,
      totalPay: model.totalPay,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    )).toList();
  }

  @override
  Future<ShiftEntity> startShift(String userId) async {
    final shiftModel = await _remoteDataSource.startShift(userId);
    return ShiftEntity(
      id: shiftModel.id,
      profileId: shiftModel.profileId,
      startTime: shiftModel.startTime,
      endTime: shiftModel.endTime,
      status: shiftModel.status,
      description: shiftModel.description,
      hourlyRate: shiftModel.hourlyRate,
      totalHours: shiftModel.totalHours,
      totalPay: shiftModel.totalPay,
      createdAt: shiftModel.createdAt,
      updatedAt: shiftModel.updatedAt,
    );
  }

  @override
  Future<ShiftEntity> endShift(String shiftId) async {
    final shiftModel = await _remoteDataSource.endShift(shiftId);
    return ShiftEntity(
      id: shiftModel.id,
      profileId: shiftModel.profileId,
      startTime: shiftModel.startTime,
      endTime: shiftModel.endTime,
      status: shiftModel.status,
      description: shiftModel.description,
      hourlyRate: shiftModel.hourlyRate,
      totalHours: shiftModel.totalHours,
      totalPay: shiftModel.totalPay,
      createdAt: shiftModel.createdAt,
      updatedAt: shiftModel.updatedAt,
    );
  }
}
