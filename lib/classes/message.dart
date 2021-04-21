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

  Message({
      @required this.message,
      @required this.sender,
      this.option,
      this.loading = false,
  });

}

class Option {
  final String message;
  final String queryForChatbot;

  Option({@required this.message, @required this.queryForChatbot});
}