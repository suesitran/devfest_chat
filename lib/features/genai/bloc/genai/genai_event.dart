part of 'genai_bloc.dart';

abstract class GenaiEvent extends Equatable {
  const GenaiEvent();
}

class StartChat extends GenaiEvent {
  @override
  List<Object?> get props => [];
}

class OnMessageReceived extends GenaiEvent {
  final String sender;
  final String message;

  const OnMessageReceived({required this.sender, required this.message});

  @override
  List<Object?> get props => [sender, message];
}