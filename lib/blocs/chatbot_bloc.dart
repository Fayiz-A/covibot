import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

abstract class ChatbotEvent {}

class SendQueryEvent extends ChatbotEvent {
  final String query;

  SendQueryEvent({@required this.query});
}

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {

  Dialogflow dialogflow;

  ChatbotBloc() : super(InitialState()) {
    _initializeDialogflow();
  }

  @override
  Stream<ChatbotState> mapEventToState(ChatbotEvent event) async* {
    if (event is SendQueryEvent) {
        String query = event.query;

        // await _initializeDialogflow();
        // AIResponse aiResponse = await dialogflow.detectIntent(query);
        // print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());

      yield ResponseSuccessfulState();
    } else {
      yield InitialState();
    }
  }

  Future<void> _initializeDialogflow() async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/services.json").build();
    dialogflow = Dialogflow(authGoogle: authGoogle,language: Language.english);
  }
}

abstract class ChatbotState {}

class InitialState extends ChatbotState {}

class ResponseSuccessfulState extends ChatbotState {}
