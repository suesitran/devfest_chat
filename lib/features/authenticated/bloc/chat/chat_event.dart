part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadChatEvent extends ChatEvent {
  final String uid;

  const LoadChatEvent(this.uid);
  @override
  List<Object?> get props => [uid];
}

class SendChatMessage extends ChatEvent {
  final Message message;

  const SendChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}
