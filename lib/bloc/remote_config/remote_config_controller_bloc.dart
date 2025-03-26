import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'remote_config_controller_event.dart';
part 'remote_config_controller_state.dart';

const String genAiKey = 'gen_ai_feature';

class RemoteConfigControllerBloc
    extends Bloc<RemoteConfigControllerEvent, RemoteConfigControllerState> {
  StreamSubscription<RemoteConfigUpdate>? _streamSubscription;

  RemoteConfigControllerBloc() : super(RemoteConfigControllerInitial()) {
    on<LoadRemoteConfigEvent>(_loadRemoteConfig);

    _init();
  }

  void _init() async {
    await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 3),
        minimumFetchInterval: Duration(milliseconds: 1)));
    if (!kIsWeb) {
      _streamSubscription ??=
          FirebaseRemoteConfig.instance.onConfigUpdated.listen(
        (event) async {
          add(LoadRemoteConfigEvent());
        },
      );
    }
    add(LoadRemoteConfigEvent());
  }

  void _loadRemoteConfig(LoadRemoteConfigEvent event,
      Emitter<RemoteConfigControllerState> emit) async {
    await FirebaseRemoteConfig.instance.fetchAndActivate();

    final bool genAi = FirebaseRemoteConfig.instance.getBool(genAiKey);

    emit(RemoteConfigUpdatedState(genAi));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
