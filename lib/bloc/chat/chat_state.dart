part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class ChatLoaded extends ChatState {
  final String uid;
  final List<Message> messages;

  const ChatLoaded(this.uid, this.messages);

  @override
  List<Object?> get props => messages;
}
