import 'dart:convert';
import 'dart:io';

import 'package:covibot/classes/message.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:covibot/getX/data_holders/api_data_holder.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum SuggestionType { state, district, none }

class ChatSuggestionsController extends GetxController {
  Map<String, dynamic> statesAndDistricts;

  @override
  void onInit() {
    try {
      http.get(constants.statesAndDistrictsURL).then((value) async {
        statesAndDistricts = await jsonDecode(value.body);
        Get.find<ApiDataHolder>().setStatesAndDistricts(statesAndDistricts);
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
  Rx<String> userQuery = ''.obs;

  Rx<SuggestionType> suggestionType = SuggestionType.state.obs;
  Rx<String> suggestionSelected = ''.obs;
  
  void changeQuery(String query) {
    userQuery.value = query;
    if(userQuery.value != null && userQuery.value.trim().isNotEmpty) {
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
      suggestions.value = [];
      shouldShowSuggestions.value = false;
    }
  }

  void changeSendUserQuery(bool shouldSend) {
    sendUserQuery.value = shouldSend;
  }
  
  void changeSuggestionType(SuggestionType suggestionTypeValue) {
    suggestionType.value = suggestionTypeValue;
    suggestions.value = [];
  }
  
  void setSuggestionSelected(String suggestion) {
    print('Suggestion selected by the user now is $suggestion');
    suggestionSelected.value = suggestion;
    suggestions.value = [];
    shouldShowSuggestions.value = false;
  }
  
  void _filterStates() {
    if(statesAndDistricts != null) {
      shouldShowSuggestions.value = true;

      List<Option> suggestionsList = [];

      statesAndDistricts.forEach((key, value) {
        if(key.trim().toLowerCase().contains(userQuery.value.trim().toLowerCase())) {
          suggestionsList.add(Option(queryForChatbot: key, message: key));
        }
      });

      suggestions.value = suggestionsList;
    }
  }

  void _filterDistricts() {
    if(statesAndDistricts != null && suggestionSelected != null) {
      shouldShowSuggestions.value = true;

      List<Option> suggestionsList = [];

      if(statesAndDistricts[suggestionSelected.value] != null) {
        List<dynamic> districts = statesAndDistricts[suggestionSelected.value];
        districts.forEach(
            (district) {
              if(district.trim().toLowerCase().contains(userQuery.value.trim().toLowerCase())) {
                suggestionsList.add(Option(queryForChatbot: district, message: district));
              }
            }
        );

        suggestions.value = suggestionsList;
      }
    }
  }
}
