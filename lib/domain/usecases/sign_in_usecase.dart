import '../repositories/user_repository.dart';

class SignInUseCase {
  final UserRepository _userRepository;

  const SignInUseCase(this._userRepository);

  Future<void> call(String email, String password) async {
    return await _userRepository.signInWithEmail(email, password);
  }
}
