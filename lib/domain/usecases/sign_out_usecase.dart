import '../repositories/user_repository.dart';

class SignOutUseCase {
  final UserRepository _userRepository;

  const SignOutUseCase(this._userRepository);

  Future<void> call() async {
    return await _userRepository.signOut();
  }
}
