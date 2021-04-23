import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {}

class ChangeFontStyleEvent extends SettingsEvent {
  final double fontSize;

  ChangeFontStyleEvent({@required this.fontSize});
}

class ChangeLanguageEvent extends SettingsEvent {
  final Locale locale;

  ChangeLanguageEvent(this.locale);
}


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(ThemeChangedState(themeMode: ThemeMode.light, fontSize: 20.0));

  ThemeMode themeMode = ThemeMode.light;
  double fontSize = 20.0;

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ToggleThemeEvent) {

      themeMode = themeMode == ThemeMode.light ? ThemeMode.dark:ThemeMode.light;

    } else if(event is ChangeFontStyleEvent) {

      fontSize = event.fontSize;

    } else if(event is ChangeLanguageEvent) {
      ChatbotBloc chatbotBloc = ChatbotBloc();
      chatbotBloc.add(ChangeChatbotLocale(event.locale));
    }

    yield ThemeChangedState(themeMode: themeMode, fontSize: fontSize);
  }
}

abstract class SettingsState {
  final ThemeMode themeMode;
  final double fontSize;

  SettingsState(this.themeMode,this.fontSize);
}

class ThemeChangedState extends SettingsState {
  final ThemeMode themeMode;
  final double fontSize;

  ThemeChangedState({@required this.themeMode, @required this.fontSize}) :super(themeMode, fontSize);

}