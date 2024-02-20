import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/chat_widgets.dart';
import 'bloc/chat/chat_bloc.dart';

class PublicChatScreen extends StatelessWidget {
  final String uid;
  const PublicChatScreen({required this.uid, super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc()..add(LoadChatEvent(uid)),
        child: _ChatBlocBody(),
      );
}

class _ChatBlocBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        if (state is ChatLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child: ListView(
                  reverse: true,
                  children: state.messages
                      .map((e) => ChatBubble(
                          text: e.message,
                          senderUid: e.senderUid,
                          isMine: e.senderUid == state.uid))
                      .toList(),
                )),
                MessageBoxView(
                  onSend: (value) =>
                      context.read<ChatBloc>().add(SendChatMessage(value)),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      });
}
