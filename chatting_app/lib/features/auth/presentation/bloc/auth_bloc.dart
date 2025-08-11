// auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/features/auth/domain/entity/user.dart';
import 'package:chatting_app/features/auth/domain/usecase/get_me_usecase.dart';
import 'package:chatting_app/features/auth/domain/usecase/log_out_usecase.dart';
import 'package:chatting_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:chatting_app/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:chatting_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogOutUsecase logOutUsecase;
  final LoginUsecase loginUsecase;
  final SignUpUsecase signUpUsecase;
  final GetMeUsecase getMeUsecase;

  AuthBloc({
    required this.logOutUsecase,
    required this.loginUsecase,
    required this.signUpUsecase,
    required this.getMeUsecase,
  }) : super(InitialState()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<LogOutEvent>(_onLogOutEvent);
    on<GetMeEvent>(_onGetMeEvent);
  }

  void _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    try {
      debugPrint('Starting login usecase...');
      final result = await loginUsecase(event.email, event.password);
      result.fold(
        (failure) {
          emit(ErrorState(message: failure.message));
        },
        (user) {
          emit(Authenticated(user));
        },
      );
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogOutEvent(
    LogOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingState());
    try {
      final result = await logOutUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (_) => emit(LoggedOutState()),
      );
    } catch (e) {
      emit(ErrorState(message: 'Unexpected error: $e'));
    }
  }

  Future<void> _onSignUpEvent(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingState());
    try {
      final result = await signUpUsecase(
        event.name,
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (_) => emit(SignedUpState()),
      );
    } catch (e) {
      emit(ErrorState(message: 'Unexpected error: $e'));
    }
  }

  Future<void> _onGetMeEvent(GetMeEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    try {
      final result = await getMeUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(Authenticated(success)),
      );
    } on AuthException catch (_) {
      emit(UnAuthenticated());
    } catch (e) {
      emit(ErrorState(message: 'Unexpected error: $e'));
    }
  }
}
