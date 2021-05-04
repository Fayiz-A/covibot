import 'dart:convert';
import 'dart:io';

import 'package:covibot/classes/message.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum SuggestionType { state, district, none }

class SuggestionsController extends GetxController {
  Map<String, dynamic> statesAndDistricts;

  @override
  void onInit() {
    try {
      http.get(constants.statesAndDistrictsURL).then((value) async {
        statesAndDistricts = await jsonDecode(value.body);
      });
    } on SocketException catch (e) {
      print('No internet connection $e');
    } catch (e) {
      print('Error occurred is fetching states $e');
    }

    super.onInit();
  }

  Rx<bool> sendUserQuery = false.obs;
  Rx<bool> shouldShowSuggestions = false.obs;
  RxList<Option> suggestions = <Option>[].obs;
  Rx<String> _userQuery = ''.obs;

  Rx<SuggestionType> suggestionType = SuggestionType.none.obs;

  void changeQuery(String query) {
    _userQuery.value = query;
    if(_userQuery.value != null && _userQuery.value.isNotEmpty) {
      switch(suggestionType.value) {
        case SuggestionType.state:
          _filterStates();
        break;
        case SuggestionType.district:
          _filterDistricts();
        break;
        case SuggestionType.none:
          print('No suggestions to be suggested');
        break;
        default: print('No suggestions to be suggested');
      }
    } else {
      shouldShowSuggestions.value = false;
    }
  }

  void _filterStates() {
    if(statesAndDistricts != null) {
      shouldShowSuggestions.value = true;

      List<Option> suggestionsList = [];

      Map<String, dynamic> statesMatched = Map.from(statesAndDistricts)..removeWhere((k, v) => !k.trim().toLowerCase().contains(_userQuery.value.trim().toLowerCase()));
      statesMatched.forEach((key, value) {
        suggestionsList.add(Option(queryForChatbot: key, message: key));
      });

      suggestions.value = suggestionsList;
    }
  }

  void _filterDistricts() {

  }
}
