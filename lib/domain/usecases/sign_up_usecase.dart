import '../repositories/user_repository.dart';

class SignUpUseCase {
  final UserRepository _userRepository;

  const SignUpUseCase(this._userRepository);

  Future<void> call(String email, String password, String name) async {
    return await _userRepository.signUpWithEmail(email, password, name);
  }
}
