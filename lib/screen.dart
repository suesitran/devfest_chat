import 'package:devfest_chat/features/authenticated/authenticated_screen.dart';
import 'package:devfest_chat/features/authenticated/public_chat/public_chat_screen.dart';
import 'package:devfest_chat/features/unauthenticated/unauthenticated_screen.dart';
import 'package:devfest_chat/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:devfest_chat/generated/l10n.dart';
import 'package:devfest_chat/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Image.network(state.user.photoURL!,
                              width: 45,
                              height: 45,
                              errorBuilder: (context, error, stackTrace) =>
                                  SvgPicture.asset(Assets.anonymous)),
                        ),
                        const SizedBox(width: 8.0,),
                        Text(S.current.signOut)
                      ],
                    ));
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(S.current.error(state.error)),
            ));
          }
        },
        builder: (context, state) {
          if (state is Authenticated) {
            return AuthenticatedScreen(uid: state.user.uid);
          }

          return const UnauthenticatedView();
        },
      ));
}
