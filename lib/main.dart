import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:covibot/blocs/internet_connnection_bloc.dart';
import 'package:covibot/blocs/settings_bloc.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:covibot/screens/chatbot_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'UK'), Locale('hi', 'IN')],
      path: 'assets/lang',
      saveLocale: true,
      fallbackLocale: Locale('en', 'UK'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale locale = context.locale;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (BuildContext context) => ChatbotBloc()
            ..chatbotLocale = locale
            ..add(SendMessageFromChatbotEvent(
                message: constants.initialMessageFromChatbot)),
        ),
        BlocProvider(
            create: (BuildContext context) => SettingsBloc(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          return MaterialApp(
            title: 'CoviBot',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            home: MultiBlocProvider(providers: [
              BlocProvider(
                lazy: false,
                create: (BuildContext context) => ChatbotBloc()
                  ..chatbotLocale = locale
                  ..add(SendMessageFromChatbotEvent(
                      message: constants.initialMessageFromChatbot.tr())),
              ),
              BlocProvider(
                create: (BuildContext context) => InternetConnectionBloc(),
              ),
            ], child: SafeArea(top: false, child: SettingsPage())),
          );
        }
      ),
    );
  }
}
