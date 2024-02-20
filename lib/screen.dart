import 'package:devfest_chat/widgets/chat_widgets.dart';
import 'package:flutter/material.dart';
import 'package:devfest_chat/generated/l10n.dart';
import 'package:devfest_chat/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:devfest_chat/bloc/chat/chat_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(S.current.appTitle),
        actions: [
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return TextButton(
                    onPressed: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(RequestSignOutEvent());
                    },
                    child: Text(S.current.signOut));
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<ChatBloc>().add(LoadChatEvent(state.user));
          }

          if (state is AuthenticationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(S.current.error(state.error)),
            ));
          }
        },
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
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
                            onSend: (value) => context
                                .read<ChatBloc>()
                                .add(SendChatMessage(value)),
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

          // not authenticated
          return Center(
            child: TextButton(
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(SignInWithGoogleEvent());
              },
              child: Text(S.current.signIn),
            ),
          );
        },
      ));
}