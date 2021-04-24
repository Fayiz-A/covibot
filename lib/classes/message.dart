import 'package:flutter/material.dart';

enum Sender {
  chatbot,
  user
}

class Message {
  final String message;
  final Sender sender;
  final Option option;
  final bool loading;
  final String action; // what to do next if sent from chatbot
  final bool sendMessageToDialogFlow;

  Message({
      @required this.message,
      @required this.sender,
      this.option,
      this.loading = false,
      this.action,
      this.sendMessageToDialogFlow = true
  });

}

class Option {
  final String message;
  final String queryForChatbot;

  Option({@required this.message, @required this.queryForChatbot});
}