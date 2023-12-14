part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthenticationState {
  const Unauthenticated();

  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthenticationState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationError extends AuthenticationState {
  final String error;

  const AuthenticationError(this.error);

  @override
  List<Object?> get props => [error];
}
