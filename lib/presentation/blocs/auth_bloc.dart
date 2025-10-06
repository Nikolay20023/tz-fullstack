import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  SignUpEvent(this.email, this.password, this.name);
}

class SignOutEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {}

abstract class AuthBlocState {}

class AuthInitial extends AuthBlocState {}

class AuthLoading extends AuthBlocState {}

class AuthAuthenticated extends AuthBlocState {
  final UserEntity user;

  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthBlocState {}

class AuthError extends AuthBlocState {
  final String message;

  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _signOutUseCase = signOutUseCase,
       super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthBlocState> emit) async {
    emit(AuthLoading());
    try {
      await _signInUseCase.call(event.email, event.password);
      final user = await _getCurrentUserUseCase.call();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Failed to get user data'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthBlocState> emit) async {
    emit(AuthLoading());
    try {
      await _signUpUseCase.call(event.email, event.password, event.name);
      final user = await _getCurrentUserUseCase.call();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Failed to get user data'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthBlocState> emit) async {
    emit(AuthLoading());
    try {
      await _signOutUseCase.call();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGetCurrentUser(GetCurrentUserEvent event, Emitter<AuthBlocState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _getCurrentUserUseCase.call();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
