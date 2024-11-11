import 'package:devfest_chat/bloc/remote_config/remote_config_controller_bloc.dart';
import 'package:devfest_chat/features/authenticated/genai/bloc/genai/genai_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/chat_widgets.dart';

class GenaiScreen extends StatelessWidget {
  final String uid;
  final String displayName;

  const GenaiScreen({required this.uid, required this.displayName, super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<GenaiBloc>(
        create: (context) => GenaiBloc(uid: uid)..add(StartChat(displayName)),
        child: _GenaiBody(),
      );
}

class _GenaiBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocConsumer<GenaiBloc, GenaiState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GenaiInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                        reverse: true,
                        children: state.messages.map((e) {
                          return ChatBubble(
                              text: e.message,
                              senderUid: e.senderUid,
                              isMine: e.senderUid == state.uid);
                        }).toList(),
                      )),
                  MessageBoxView(
                    onSend: (value) => context.read<GenaiBloc>().add(
                        SendChatToGenAI(
                            sender: value.senderUid,
                            message: value.message)),
                  ),
                ],
              ),
            );
          });
}
