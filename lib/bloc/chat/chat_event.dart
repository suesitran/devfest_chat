part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadChatEvent extends ChatEvent {
  final User user;

  const LoadChatEvent(this.user);
  @override
  List<Object?> get props => [user];
}

class SendChatMessage extends ChatEvent {
  final Message message;

  const SendChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}