import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/supabase_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseRemoteDataSource _remoteDataSource;

  const UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _remoteDataSource.getCurrentUser();
    if (userModel != null) {
      return UserEntity(
        id: userModel.id,
        email: userModel.email,
        name: userModel.name,
        avatarUrl: userModel.avatarUrl,
      );
    }
    return null;
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    return await _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<void> signUpWithEmail(String email, String password, String name) async {
    return await _remoteDataSource.signUpWithEmail(email, password, name);
  }

  @override
  Future<void> signOut() async {
    return await _remoteDataSource.signOut();
  }
}
