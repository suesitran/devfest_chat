import 'package:devfest_chat/features/authenticated/genai/genai_screen.dart';
import 'package:devfest_chat/features/authenticated/public_chat/public_chat_screen.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class AuthenticatedScreen extends StatefulWidget {
  final String uid;

  const AuthenticatedScreen({required this.uid, super.key});

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
  late final TabController _controller = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TabBar(
            tabs: AuthenticatedTabs.values.map((e) => e.widget).toList(),
            controller: _controller,
          ),
          Expanded(
              child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              PublicChatScreen(uid: widget.uid),
              GenaiScreen(uid: widget.uid)
            ],
          ))
        ],
      );
}
