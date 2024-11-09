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
      history: history.docs.map((e) {
        if (e.data().senderUid == _modelName) {
          return Content.model(
              [TextPart('${e.data().time.toString()}, ${e.data().message}')]);
        }

        return Content.text('${e.data().time.toString()}, ${e.data().message}');
      }).toList(),
      generationConfig: GenerationConfig(
        temperature: 0.8,
      ),
      // safetySettings: [
      //   SafetySetting(
      //       HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      //   SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      //   SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
      //   SafetySetting(
      //       HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
      //   SafetySetting(HarmCategory.unspecified, HarmBlockThreshold.low)
      // ]
    );
    
    _chatSession?.sendMessage(Content.multi([
      TextPart('Act as a friendly and funny chat bot to chat with user'),
      TextPart('Always response in user\'s language'),
      TextPart('And if asked, your name is GemiVin, which means Gemini for Vietnam'),
    ]));

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
    final GenerateContentResponse? response =
        await _chatSession?.sendMessage(Content.multi([
      TextPart(event.message),
      TextPart('please response casually, and make it short'),
      TextPart('response in the same language the user is using')
    ]));

    if (response == null) {
      // do nothing
    } else {
      _firebaseFirestore
          .collection(_collectionGenAI)
          .doc(state.uid)
          .collection(_collectionChatMessages)
          .add(Message(
                  time: DateTime.now(),
                  senderUid: _modelName,
                  message: response.text ?? 'Sorry I\'m unable to answer that.')
              .toMap());
    }
  }
}
