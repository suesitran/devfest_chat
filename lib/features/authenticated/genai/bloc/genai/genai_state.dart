part of 'genai_bloc.dart';

abstract class GenaiState extends Equatable {
  final String uid;
  final List<Message> messages;
  const GenaiState({required this.uid, required this.messages});
}

class GenaiInitial extends GenaiState {
  GenaiInitial({required String uid}) : super(uid: uid, messages: []);

  @override
  List<Object> get props => [];
}

class GenaiLoading extends GenaiState {
  const GenaiLoading({required super.uid, required super.messages});

  @override
  List<Object?> get props => [];
}

class GenaiReady extends GenaiState {
  const GenaiReady({required super.uid, required super.messages});

  @override
  List<Object?> get props => [...messages];
}
