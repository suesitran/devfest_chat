import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../../../data/data.dart';

part 'genai_event.dart';
part 'genai_state.dart';

const String _modelName = 'model';
const String _collectionGenAI = 'genai';
const String _collectionChatMessages = 'messages';

class GenaiBloc extends Bloc<GenaiEvent, GenaiState> {
  final FirebaseFirestore _firebaseFirestore;
  final String _apiKey = 'AIzaSyBdzct8an0515Cm82yvQai4k4pMkWSZ_HM';
  ChatSession? _chatSession;

  GenaiBloc({FirebaseFirestore? firebaseFirestore, required String uid})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        super(GenaiInitial(uid: uid)) {
    on<SendChatToGenAI>(_sendChatMessage);

    on<StartChat>(_startChat);

    on<StartChatStreaming>(_startStreaming);
  }

  void _startChat(StartChat event, Emitter<GenaiState> emit) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);

    // collect all history
    final QuerySnapshot<Message> history = await _firebaseFirestore
        .collection(_collectionGenAI)
        .doc(state.uid)
        .collection(_collectionChatMessages)
        .orderBy('time', descending: true)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Message.fromMap(snapshot.id, snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toMap(),
        )
        .get(const GetOptions(source: Source.serverAndCache));

    _chatSession = model.startChat(
      history: [
        Content.multi([
          TextPart('You are chatting with ${event.displayName}'),
          TextPart('Act as a friendly and funny chat bot to chat with user'),
          TextPart('Always response in user\'s language'),
          TextPart(
              'And if asked, your name is GemiVin, which means Gemini for Vietnam. The name Gemini is not to be translated to any language'),
        ]),
        ...history.docs.map((e) {
          if (e.data().senderUid == _modelName) {
            return Content.model([TextPart(e.data().message)]);
          }

          return Content.text(e.data().message);
        }).toList()
      ],
    );

    add(StartChatStreaming());
  }

  void _startStreaming(
      StartChatStreaming event, Emitter<GenaiState> emit) async {
    await emit.forEach(
      _firebaseFirestore
          .collection(_collectionGenAI)
          .doc(state.uid)
          .collection(_collectionChatMessages)
          .orderBy('time', descending: true)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                Message.fromMap(snapshot.id, snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toMap(),
          )
          .snapshots(includeMetadataChanges: true),
      onData: (data) {
        return GenaiReady(
            uid: state.uid, messages: data.docs.map((e) => e.data()).toList());
      },
    );
  }

  void _sendChatMessage(SendChatToGenAI event, Emitter<GenaiState> emit) async {
    _firebaseFirestore
        .collection(_collectionGenAI)
        .doc(state.uid)
        .collection(_collectionChatMessages)
        .add(Message(
                time: DateTime.now(),
                senderUid: event.sender,
                message: event.message)
            .toMap());

    String rep;
    try {
      final GenerateContentResponse? response =
          await _chatSession?.sendMessage(Content.multi([
        TextPart(event.message),
        TextPart('response in the same language the user is using')
      ]));
      rep = response?.text ?? 'Unable to response by text';
    } on GenerativeAIException catch (e) {
      rep = 'Unable to response because ${e.message}';
    } on GenerativeAISdkException catch (e) {
      rep = 'Unable to response because ${e.message}';
    } catch (e) {
      rep = 'Unable to response ${e.toString()}';
    }

    _firebaseFirestore
        .collection(_collectionGenAI)
        .doc(state.uid)
        .collection(_collectionChatMessages)
        .add(Message(time: DateTime.now(), senderUid: _modelName, message: rep)
            .toMap());
  }
}
