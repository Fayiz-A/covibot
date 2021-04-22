import 'package:flutter/material.dart';

bool checkLocaleEquality(Locale locale1, Locale locale2) {
  if(locale1.languageCode == locale2.languageCode && locale1.countryCode == locale2.countryCode) {
    return true;
  }
  return false;
}