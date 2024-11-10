part of 'remote_config_controller_bloc.dart';

sealed class RemoteConfigControllerState extends Equatable {
  const RemoteConfigControllerState();
}

final class RemoteConfigControllerInitial extends RemoteConfigControllerState {
  @override
  List<Object> get props => [];
}

final class RemoteConfigUpdatedState extends RemoteConfigControllerState {
  final Map<String, dynamic> values;

  const RemoteConfigUpdatedState(this.values);

  @override
  List<Object?> get props => [...values.keys, ...values.values];
}
