import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const String emptyStringQuery = 'nothing in query with passcode abc@77';
String initialMessageFromChatbot = 'DefaultMessage';
String noInternetMessage = 'noInternetMessage'.tr();
String errorMessage = 'errorMessage'.tr();

const Duration messageDurationForCornerCaseMessages = Duration(milliseconds: 1500);
const Duration durationBeforeRenderingProgressIndicator = Duration(milliseconds: 150);
const Duration fadeDurationBetweenProgressIndicatorAndMessage = Duration(milliseconds: 200);

const ThemeMode defaultThemeMode = ThemeMode.dark;
const double defaultFontSize = 20.0;