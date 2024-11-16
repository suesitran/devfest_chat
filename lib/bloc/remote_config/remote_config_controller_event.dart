part of 'remote_config_controller_bloc.dart';

sealed class RemoteConfigControllerEvent extends Equatable {
  const RemoteConfigControllerEvent();
}

final class RegisterConfigUpdateEvent extends RemoteConfigControllerEvent {
  @override
  List<Object?> get props => [];
}

final class LoadRemoteConfigEvent extends RemoteConfigControllerEvent {
  @override
  List<Object?> get props => [];
}
