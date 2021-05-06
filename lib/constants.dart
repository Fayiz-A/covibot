import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const String primaryEndpoint = 'life-pipeline.coronasafe.network';
const String endpointConcatenateString = '/api/resources';

const String emptyStringQuery = 'nothing in query with passcode abc@77';
const String initialMessageFromChatbot = 'DefaultMessage';
String noInternetMessage = 'NoInternetMessage'.tr();
String errorMessage = 'ErrorMessage'.tr();

const Duration messageDurationForCornerCaseMessages = Duration(milliseconds: 1500);
const Duration durationBeforeRenderingProgressIndicator = Duration(milliseconds: 500);
const Duration fadeDurationBetweenProgressIndicatorAndMessage = Duration(milliseconds: 200);

const ThemeMode defaultThemeMode = ThemeMode.dark;
const double defaultFontSize = 20.0;

const String apiFetchKeyword = 'askDistrict';

const double bigWindowSize = 800;

const statesAndDistrictsURL = 'https://life-api.coronasafe.network/data/states.json';