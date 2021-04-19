import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:covibot/screens/chatbot_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.red,
          splashFactory: InkRipple.splashFactory,
          textTheme: TextTheme(
            bodyText1: TextStyle(fontSize: 20),
          ),
          tooltipTheme: TooltipThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.black.withOpacity(0.6),
            ),
          )
      ),
      home: BlocProvider(
          create: (BuildContext context) => ChatbotBloc(),
          child: SafeArea(top: false, child: ChatbotPage())),
    );
  }
}
