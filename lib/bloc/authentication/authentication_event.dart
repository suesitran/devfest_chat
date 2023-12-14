part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class ValidateAuthenticationEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class SignInWithGoogleEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class RequestSignOutEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}
