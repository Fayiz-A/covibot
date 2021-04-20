import 'package:flutter/material.dart';

enum Sender {
  chatbot,
  user
}

class Message {
  final String message;
  final Sender sender;
  // final List<String> options;

  Message({
      @required this.message,
      @required this.sender
  });

}