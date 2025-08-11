part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {}

class LoadingState extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}


class UnAuthenticated extends AuthState{
}

class LoggedOutState extends AuthState {}

class SignedUpState extends AuthState {}

class ErrorState extends AuthState {
  final String message;

  const ErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
