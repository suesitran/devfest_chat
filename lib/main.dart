import 'package:devfest_chat/bloc/authentication/authentication_bloc.dart';
import 'package:devfest_chat/bloc/chat/chat_bloc.dart';
import 'package:devfest_chat/bloc/user_detail/user_detail_bloc.dart';
import 'package:devfest_chat/firebase_options.dart';
import 'package:devfest_chat/widgets/chat_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc()..add(ValidateAuthenticationEvent()),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(),
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Text('Public Chat'),
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
                        child: Text('Sign out'));
                  }

                  return SizedBox.shrink();
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
                  content: Text("Error: ${state.error}"),
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

                  return Center(
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
                  child: Text('Sign in'),
                ),
              );
            },
          )),
    ));
  }
}
