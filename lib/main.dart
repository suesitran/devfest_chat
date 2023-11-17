import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_chat/firebase_options.dart';
import 'package:devfest_chat/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat_widgets.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Public chat'),
          actions: [
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) => snapshot.data == null
                  ? SizedBox.shrink()
                  : TextButton(
                      onPressed: () => LoginWithGoogle().signOut(),
                      child: Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white),
                      )),
            )
          ],
        ),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final User? user = snapshot.data;

            if (user == null) {
              // unauthenticated
              return Center(
                child: TextButton(
                  child: Text('Sign in'),
                  onPressed: () {
                    // TODO google sign in
                    LoginWithGoogle().signIn();
                  },
                ),
              );
            }

            return StreamBuilder<QuerySnapshot<Message>>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .withConverter(
                    fromFirestore: (snapshot, options) =>
                        Message.fromMap(snapshot.id, snapshot.data() ?? {}),
                    toFirestore: (value, options) => value.toMap(),
                  )
                  .snapshots(includeMetadataChanges: true),
              builder: (context, snapshot) {
                final QuerySnapshot<Message>? data = snapshot.data;
                return Column(
                  children: [
                    Expanded(
                        child: ListView(
                      reverse: true,
                      children: data?.docs.map((e) {
                            final Message message = e.data();

                            return ChatBubble(
                                text: message.message,
                                senderUid: message.senderUid,
                                isMine: message.senderUid == user.uid);
                          }).toList() ??
                          [],
                    )),
                    MessageBoxView(
                      onSend: (value) => FirebaseFirestore.instance
                          .collection('messages')
                          .doc()
                          .set(value.toMap()),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
