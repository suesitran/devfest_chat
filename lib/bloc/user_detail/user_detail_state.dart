part of 'user_detail_bloc.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();
}

class UserDetailInitial extends UserDetailState {
  @override
  List<Object> get props => [];
}

class UserDetailLoaded extends UserDetailState {
  final UserDetail userDetail;

  UserDetailLoaded(this.userDetail);

  @override
  List<Object?> get props => [userDetail];
}

class LoadUserDetailFailed extends UserDetailState {
  @override
  List<Object?> get props => [];
}
