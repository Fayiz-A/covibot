import 'package:covibot/classes/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

import 'package:covibot/constants.dart' as constants;

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

  List<Message> chatList = [];

  @override
  Stream<ChatbotState> mapEventToState(ChatbotEvent event) async* {
    if (event is SendQueryEvent) {
      String query = event.query;

      if (query == null || query
          .trim()
          .length == 0) query = constants.emptyStringQuery;

      Message userMessage = Message(sender: Sender.user, message: event.query);
      chatList.insert(0, userMessage);

      yield MessageAddedState(chatList: chatList);

      await _initializeDialogflow();
      AIResponse aiResponse = await dialogflow.detectIntent(query);

      List responseListMessages = aiResponse.getListMessage();

      String responseFromChatbot = responseListMessages[0]["text"]["text"][0]
          .toString();

      Message chatbotMessage = Message(sender: Sender.chatbot, message: responseFromChatbot);

      chatList.insert(0, chatbotMessage);

      if (responseListMessages.length == 2 &&
          responseListMessages[1]["payload"] != null) {
        List options = responseListMessages[1]["payload"]["options"];

        for(int index = 0; index < options.length; index++) {
          var option = options[index];

          chatList.insert(0,
            Message(
                sender: Sender.chatbot,
                message: responseFromChatbot,
                option: Option(
                    queryForChatbot: options[index]["query"],
                    message: options[index]["text"])
            ),
          );
        }
      }

      print('response: $responseFromChatbot');

      yield MessageAddedState(chatList: chatList);
    } else {
      yield InitialState();
    }
  }

  Future<void> _initializeDialogflow() async {
    AuthGoogle authGoogle =
    await AuthGoogle(fileJson: "assets/services.json").build();
    dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
  }
}

abstract class ChatbotState {}

class InitialState extends ChatbotState {}

class ResponseLoadingState extends ChatbotState {}

class ResponseErrorState extends ChatbotState {}

class MessageAddedState extends ChatbotState {
  final List<Message> chatList;

  MessageAddedState({@required this.chatList});
}
