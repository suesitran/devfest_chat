import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_chat/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String _collectionMessages = 'messages';

  final FirebaseFirestore _firebaseFirestore;

  ChatBloc({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        super(ChatInitial()) {
    on<LoadChatEvent>((event, emit) async {
      await emit.forEach(
          _firebaseFirestore
              .collection(_collectionMessages)
              .orderBy('time', descending: true)
              .withConverter(
                fromFirestore: (snapshot, options) =>
                    Message.fromMap(snapshot.id, snapshot.data() ?? {}),
                toFirestore: (value, options) => value.toMap(),
              )
              .snapshots(includeMetadataChanges: true), onData: (data) {
        return ChatLoaded(
            event.user.uid, data.docs.map((e) => e.data()).toList());
      });
    });

    on<SendChatMessage>((event, emit) async {
      _firebaseFirestore
          .collection(_collectionMessages)
          .doc()
          .set(event.message.toMap());
    });
  }
}
