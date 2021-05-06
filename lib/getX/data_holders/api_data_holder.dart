import 'package:flutter/material.dart';
import 'package:get/get.dart';

//holds anything important fetched from an api in the app
class ApiDataHolder extends GetxController {
  RxMap<dynamic, dynamic> statesAndDistricts = {}.obs;

  void setStatesAndDistricts(Map<dynamic, dynamic> _statesAndDistricts) {
    statesAndDistricts.value = _statesAndDistricts;
  }
}