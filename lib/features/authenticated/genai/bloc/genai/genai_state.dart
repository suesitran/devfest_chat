part of 'genai_bloc.dart';

abstract class GenaiState extends Equatable {
  const GenaiState();
}

class GenaiInitial extends GenaiState {
  @override
  List<Object> get props => [];
}
