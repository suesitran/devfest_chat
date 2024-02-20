import 'package:flutter/material.dart';
class GenaiScreen extends StatelessWidget {
  final String uid;

  const GenaiScreen({required this.uid, super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Text('GenAI'),
  );
}