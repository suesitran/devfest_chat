import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../generated/l10n.dart';

class UnauthenticatedView extends StatelessWidget {
  const UnauthenticatedView({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: TextButton(
          onPressed: () {
            context.read<AuthenticationBloc>().add(SignInWithGoogleEvent());
          },
          child: Text(S.current.signIn),
        ),
      );
}
