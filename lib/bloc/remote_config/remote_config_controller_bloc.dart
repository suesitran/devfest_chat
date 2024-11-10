import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'remote_config_controller_event.dart';
part 'remote_config_controller_state.dart';

const String genAiKey = 'gen_ai_feature';
class RemoteConfigControllerBloc extends Bloc<RemoteConfigControllerEvent, RemoteConfigControllerState> {
  RemoteConfigControllerBloc() : super(RemoteConfigControllerInitial()) {
    on<RemoteConfigControllerEvent>((event, emit) {

    });
  }
}
