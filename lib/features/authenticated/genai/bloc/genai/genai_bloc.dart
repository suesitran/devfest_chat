import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'genai_event.dart';
part 'genai_state.dart';

const String _modelName = 'model';

class GenaiBloc extends Bloc<GenaiEvent, GenaiState> {

  final FirebaseFirestore _firebaseFirestore;
  final String _apiKey = 'AIzaSyBdzct8an0515Cm82yvQai4k4pMkWSZ_HM';
  ChatSession? _chatSession;

  GenaiBloc({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        super(GenaiInitial()) {
    on<OnMessageReceived>(_checkLastMessage);

    on<StartChat>(_startChat);
  }

  void _startChat(StartChat event, Emitter<GenaiState> emit) {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);

    _chatSession = model.startChat(history: [], generationConfig: GenerationConfig(
      temperature: 0.8,
    ),
    safetySettings: [
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.unspecified, HarmBlockThreshold.low)
    ]);
  }

  void _checkLastMessage(OnMessageReceived event, Emitter<GenaiState> emit) {
    if (event.sender == _modelName) {
      // last message is from model, ignore it
    } else {
      _chatSession?.sendMessage(Content.multi([
        TextPart('from ${event.sender}: ${event.message}'),
        TextPart('response casually')
      ]));
    }
  }
}
