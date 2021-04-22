import 'package:easy_localization/easy_localization.dart';

const String emptyStringQuery = 'nothing in query with passcode abc@77';
String initialMessageFromChatbot = 'DefaultMessage'.tr();
String noInternetMessage = 'noInternetMessage'.tr();
String errorMessage = 'errorMessage'.tr();

const Duration messageDurationForCornerCaseMessages = Duration(milliseconds: 1500);
const Duration durationBeforeRenderingProgressIndicator = Duration(milliseconds: 150);
const Duration fadeDurationBetweenProgressIndicatorAndMessage = Duration(milliseconds: 200);