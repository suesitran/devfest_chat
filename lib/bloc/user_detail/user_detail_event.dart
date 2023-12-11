part of 'user_detail_bloc.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();
}

class LoadUserDetailEvent extends UserDetailEvent {
  final String uid;

  LoadUserDetailEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}