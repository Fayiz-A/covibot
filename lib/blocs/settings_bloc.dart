import 'package:covibot/widgets/theme.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SettingsEvent {}

class ToggleThemeEvent extends SettingsEvent {}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(ThemeChangedState(themeData: theme.initialThemeData));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ToggleThemeEvent) {
      theme.themeData.brightness == Brightness.light ? theme.themeData = theme.darkThemeData:theme.themeData = theme.initialThemeData;

      yield ThemeChangedState(themeData: theme.themeData);
    } else {
      yield ThemeChangedState(themeData: theme.initialThemeData);
    }
  }
}

abstract class SettingsState {
  final ThemeData themeData;

  SettingsState({@required this.themeData});

}

class ThemeChangedState extends SettingsState {
  final ThemeData themeData;

  ThemeChangedState({@required this.themeData}): super(themeData: themeData);

}