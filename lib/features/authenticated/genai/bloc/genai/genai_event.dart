part of 'genai_bloc.dart';

abstract class GenaiEvent extends Equatable {
  const GenaiEvent();
}

class StartChat extends GenaiEvent {
  @override
  List<Object?> get props => [];
}

class StartChatStreaming extends GenaiEvent {
  @override
  List<Object?> get props => [];
}

class SendChatToGenAI extends GenaiEvent {
  final String sender;
  final String message;

  const SendChatToGenAI({required this.sender, required this.message});

  @override
  List<Object?> get props => [sender, message];
}
