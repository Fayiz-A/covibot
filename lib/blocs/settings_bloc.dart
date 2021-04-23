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

class SetInitialValuesEvent extends SettingsEvent {
  final double fontSize;
  final Locale locale;
  final ThemeMode themeMode;

  SetInitialValuesEvent({@required this.fontSize, @required this.locale, @required this.themeMode});
}


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(ThemeChangedState(themeMode: ThemeMode.light, fontSize: 20.0, locale: Locale('en', 'UK')));

  ThemeMode themeMode = ThemeMode.dark;
  double fontSize = 20.0;
  Locale locale = Locale('en', 'UK');

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {

    if(event is SetInitialValuesEvent) {
      themeMode = event.themeMode;
      fontSize = event.fontSize;
      locale = event.locale;


      yield InitialsSetState(themeMode: themeMode, fontSize: fontSize, locale: locale);

    } else if (event is ToggleThemeEvent) {

      themeMode = themeMode == ThemeMode.light ? ThemeMode.dark:ThemeMode.light;

      yield ThemeChangedState(themeMode: themeMode, fontSize: fontSize, locale: locale);

    } else if(event is ChangeFontStyleEvent) {

      fontSize = event.fontSize;

      yield ThemeChangedState(themeMode: themeMode, fontSize: fontSize, locale: locale);

    } else if(event is ChangeLanguageEvent) {
      //do something
    }

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
  final Locale locale;

  ThemeChangedState({@required this.themeMode, @required this.fontSize, @required this.locale,}) :super(themeMode, fontSize);

}

class InitialsSetState extends SettingsState {
  final ThemeMode themeMode;
  final double fontSize;
  final Locale locale;

  InitialsSetState({@required this.themeMode, @required this.fontSize, @required this.locale,}) :super(themeMode, fontSize);

}