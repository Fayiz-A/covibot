import 'package:flutter/material.dart';

ThemeData themeData = initialThemeData;

final ThemeData initialThemeData = ThemeData(
    primaryColor: Colors.red,
    splashFactory: InkRipple.splashFactory,
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 16),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.black.withOpacity(0.6),
      ),
    ));

final ThemeData lightThemeData = ThemeData(
    primaryColor: Colors.red,
    splashFactory: InkRipple.splashFactory,
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyText1: themeData.textTheme.bodyText1
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.black.withOpacity(0.6),
      ),
    ));

//FIXME: the dark theme data didn't use copyWith method as it doesn't work with brightness. This is a problem with flutter framework
final darkThemeData = ThemeData(
    primaryColor: Colors.red,
    splashFactory: InkRipple.splashFactory,
    brightness: Brightness.dark,
    textTheme: TextTheme(
        bodyText1: themeData.textTheme.bodyText1
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.white.withOpacity(0.8),
      ),
    ));

ThemeData setFontStyleThemeData(double fontSize) {
  return themeData.copyWith(
      textTheme: initialThemeData.textTheme.copyWith(bodyText1: TextStyle(fontSize: fontSize))
  );
}