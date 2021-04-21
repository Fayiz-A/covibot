import 'dart:io';

import 'package:covibot/classes/message.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

abstract class ChatbotEvent {}

class SendQueryAndYieldMessageEvent extends ChatbotEvent {
  final String query;

  SendQueryAndYieldMessageEvent({@required this.query});
}

class SendMessageFromChatbotEvent extends ChatbotEvent {
  final String message;
  final Option option;

  SendMessageFromChatbotEvent({@required this.message, this.option});
}

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  Dialogflow dialogflow;

  ChatbotBloc() : super(InitialState());

  List<Message> chatList = [];

  @override
  Stream<ChatbotState> mapEventToState(ChatbotEvent event) async* {
    if (event is SendQueryAndYieldMessageEvent) {
      String query = event.query;

      if (query == null || query.trim().length == 0)
        query = constants.emptyStringQuery;

      Message userMessage = Message(sender: Sender.user, message: event.query);
      chatList.insert(0, userMessage);

      yield MessageAddedState(chatList: chatList);

      try {
        await _addAnswerFromChatbot(message: '', loading: true);

        yield MessageAddedState(chatList: chatList);

        await _initializeDialogflow();
        AIResponse aiResponse = await dialogflow.detectIntent(query);

        List responseListMessages = aiResponse.getListMessage();

        String responseFromChatbot =
        responseListMessages[0]["text"]["text"][0].toString();

        await _addAnswerFromChatbot(message: responseFromChatbot);

        if (responseListMessages.length == 2 &&
            responseListMessages[1]["payload"] != null) {
          List options = responseListMessages[1]["payload"]["options"];

          for (int index = 0; index < options.length; index++) {
            await _addAnswerFromChatbot(
                message: responseFromChatbot,
                option: Option(
                    queryForChatbot: options[index]["query"],
                    message: options[index]["text"]));
          }
        }

        print('response: $responseFromChatbot');
      } on SocketException catch (socketException) {
        await Future.delayed(constants.messageDurationForCornerCaseMessages);

        await _addAnswerFromChatbot(
            message:
            'I am more intelligent when you are connected to the internet.');
      } catch (e) {
        await Future.delayed(constants.messageDurationForCornerCaseMessages);

        await _addAnswerFromChatbot(
            message:
            'Oops! Looks like something went wrong with me. Just like humans get ill, I also sometimes get ill. Pray that I get well soon.');
      }

      yield MessageAddedState(chatList: chatList);
    } else if (event is SendMessageFromChatbotEvent) {
      await _addAnswerFromChatbot(message: event.message, option: event.option);
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

  Future<void> _addAnswerFromChatbot(
      {Option option, @required String message, bool loading = false}) async {
    if (chatList.length > 0 && chatList[0].loading == true) {
      // for replacing the progress indicator with message
      chatList[0] = Message(
          sender: Sender.chatbot,
          message: message,
          option: option,
          loading: false);
    } else {

      if (loading == true) {
        //the one to be inserted is going to be true
        //wait for some time to remove abruptness

        await Future.delayed(constants.durationBeforeRenderingProgressIndicator);
        // chatList.insert(
        //     0,
        //     Message(
        //         sender: Sender.chatbot,
        //         message: message,
        //         option: option,
        //         loading: loading));
      }
        chatList.insert(
            0,
            Message(
                sender: Sender.chatbot,
                message: message,
                option: option,
                loading: loading));
    }
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
