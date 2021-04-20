import 'package:flutter/material.dart';

enum Sender {
  chatbot,
  user
}

class Message {
  final String message;
  final Sender sender;
  final Option option;//it is dynamic as the json was parsed that way

  Message({
      @required this.message,
      @required this.sender,
      this.option
  });

}

class Option {
  final String message;
  final String queryForChatbot;

  Option({@required this.message, @required this.queryForChatbot});
}