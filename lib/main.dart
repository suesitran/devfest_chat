import 'package:devfest_chat/bloc/authentication/authentication_bloc.dart';
import 'package:devfest_chat/bloc/chat/chat_bloc.dart';
import 'package:devfest_chat/firebase_options.dart';
import 'package:devfest_chat/generated/l10n.dart';
import 'package:devfest_chat/screen.dart';
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
        localizationsDelegates: const [
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
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
          child: const MainScreen(),
        ));
  }
}
