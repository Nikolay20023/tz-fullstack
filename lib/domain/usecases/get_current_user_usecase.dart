import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _userRepository;

  const GetCurrentUserUseCase(this._userRepository);

  Future<UserEntity?> call() async {
    return await _userRepository.getCurrentUser();
  }
}
