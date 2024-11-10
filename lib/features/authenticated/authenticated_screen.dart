import 'package:devfest_chat/features/authenticated/genai/genai_screen.dart';
import 'package:devfest_chat/features/authenticated/public_chat/public_chat_screen.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class AuthenticatedScreen extends StatefulWidget {
  final String uid;
  final String displayName;
  final bool genAI;

  const AuthenticatedScreen(
      {required this.uid,
      required this.displayName,
      required this.genAI,
      super.key});

  @override
  State<AuthenticatedScreen> createState() => _AuthenticatedScreenState();
}

enum AuthenticatedTabs {
  publicChat,
  genAI;

  Widget get widget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: switch (this) {
        AuthenticatedTabs.publicChat => Text(S.current.appTitle),
        _ => Text(S.current.genai)
      },
    );
  }
}

class _AuthenticatedScreenState extends State<AuthenticatedScreen>
    with TickerProviderStateMixin {
  late final TabController _controller =
      TabController(length: widget.genAI ? 2 : 1, vsync: this);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TabBar(
            tabs: widget.genAI
                ? AuthenticatedTabs.values.map((e) => e.widget).toList()
                : [AuthenticatedTabs.publicChat.widget],
            controller: _controller,
          ),
          Expanded(
              child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              PublicChatScreen(uid: widget.uid),
              if (widget.genAI)
                GenaiScreen(
                  uid: widget.uid,
                  displayName: widget.displayName,
                )
            ],
          ))
        ],
      );
}
