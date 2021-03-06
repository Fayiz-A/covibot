import 'dart:convert';
import 'dart:io';

import 'package:covibot/classes/general_functions/language.dart';
import 'package:covibot/classes/message.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:covibot/getX/controllers/chat_suggestions_controller.dart';
import 'package:covibot/getX/data_holders/api_data_holder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;

abstract class ChatbotEvent {}

class SendQueryAndYieldMessageEvent extends ChatbotEvent {
  final String query;
  final String action;
  final bool sendMessageToDialogFlow;

  SendQueryAndYieldMessageEvent(
      {@required this.query,
        this.action,
        this.sendMessageToDialogFlow = false});
}

class SendMessageFromChatbotEvent extends ChatbotEvent {
  final String message;
  final Option option;
  final String action;
  final bool sendMessageToDialogFlow;

  SendMessageFromChatbotEvent(
      {@required this.message,
        this.option,
        this.action,
        this.sendMessageToDialogFlow = false});
}

//TODO: Refactor this to change chatbot locale and introduce parameters for accepting locale. Right now it is toggle as there are only two locales en-UK and hi-IN
class ChangeChatbotLocale extends ChatbotEvent {
  final Locale locale;

  ChangeChatbotLocale(this.locale);
}

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  Dialogflow dialogflow;

  ChatbotBloc() : super(InitialState());

  List<Message> chatList = [];

  Locale chatbotLocale = Locale('en', 'UK');

  String actionType;
  String stateNameInAPIFormat;
  String districtNameInAPIFormat;

  @override
  Stream<ChatbotState> mapEventToState(ChatbotEvent event) async* {
    if (event is SendQueryAndYieldMessageEvent) {
      String query = event.query;

      if (query == null || query.trim().length == 0)
        query = constants.emptyStringQuery;

      Message userMessage = Message(sender: Sender.user, message: event.query);
      chatList.insert(0, userMessage);

      yield MessageAddedState(chatList: chatList);

      try {
        await _addAnswerFromChatbot(message: '', loading: true);

        yield MessageAddedState(chatList: chatList);

        if (event.sendMessageToDialogFlow) {
          if(!kIsWeb) {
            final result = await InternetAddress.lookup('example.com');
          }

          await _initializeDialogflow();
          AIResponse aiResponse = await dialogflow.detectIntent(query);

          List responseListMessages = aiResponse.getListMessage();

          String responseFromChatbot =
          responseListMessages[0]["text"]["text"][0].toString();

          String action = aiResponse.queryResult.action;

          print(action);

          if (action != null &&
              action.contains(constants.apiFetchKeyword) &&
              responseListMessages.length == 2 &&
              responseListMessages[1]["payload"] != null) {
            actionType = action
                .substring(constants.apiFetchKeyword.length)
                .trim()
                .toLowerCase();

            await _addAnswerFromChatbot(
                message: responseFromChatbot,
                action: 'askDistrict',
                sendMessageToDialogflow: false);

            Get.find<ChatSuggestionsController>()
              ..changeSendUserQuery(true)
              ..changeSuggestionType(SuggestionType.state);
          } else {
            await _addAnswerFromChatbot(message: responseFromChatbot);
          }

          if (responseListMessages.length == 2 &&
              responseListMessages[1]["payload"] != null) {
            List options = responseListMessages[1]["payload"]["options"];

            for (int index = 0; index < options.length; index++) {
              await _addAnswerFromChatbot(
                  message: responseFromChatbot,
                  option: Option(
                      queryForChatbot: options[index]["query"],
                      message: options[index]["text"]));
            }
          }

          print('response: $responseFromChatbot');
        } else {
          Map<dynamic, dynamic> statesAndDistricts =
              Get.find<ApiDataHolder>().statesAndDistricts;

          if (event.action == 'askDistrict') {
            statesAndDistricts.forEach((stateName, value) {
              if (stateName
                  .trim()
                  .toLowerCase()
                  .contains(query.trim().toLowerCase())) {
                stateNameInAPIFormat = stateName;
              }
            });

            if (stateNameInAPIFormat == null) {
              await _addAnswerFromChatbot(
                  message: 'StateNotAvailable'.tr(), waitForSometime: true);

              Get.find<ChatSuggestionsController>()
                ..changeSendUserQuery(false)
                ..changeSuggestionType(SuggestionType.none);
            } else {
              Get.find<ChatSuggestionsController>()
                ..setSuggestionSelected(stateNameInAPIFormat)
                ..changeSendUserQuery(true)
                ..changeSuggestionType(SuggestionType.district);
              await _addAnswerFromChatbot(
                  message: 'AskDistrict'.tr(),
                  action: 'fetchResult',
                  sendMessageToDialogflow: false,
                  waitForSometime: true);
            }

          } else if (event.action == 'fetchResult') {
            Get.find<ChatSuggestionsController>()
              ..changeSendUserQuery(false)
              ..changeSuggestionType(SuggestionType.none);

            if (statesAndDistricts[stateNameInAPIFormat] != null) {
              List<dynamic> districts =
              statesAndDistricts[stateNameInAPIFormat];
              districts.forEach((district) {
                if (district
                    .trim()
                    .toLowerCase()
                    .contains(query.trim().toLowerCase())) {
                  districtNameInAPIFormat = district;
                }
              });

              if(districtNameInAPIFormat != null) {
                await _sendMessageAccordingly(actionType);
              } else {
                await _addAnswerFromChatbot(
                    message: 'DistrictNotAvailable'.tr(), waitForSometime: true);
              }

              Get.find<ChatSuggestionsController>()
                ..changeSendUserQuery(false)
                ..changeSuggestionType(SuggestionType.none);
            } else {
              await _addAnswerFromChatbot(
                  message: 'StateNotAvailable'.tr(), waitForSometime: true);

              Get.find<ChatSuggestionsController>()
                ..changeSendUserQuery(false)
                ..changeSuggestionType(SuggestionType.none);
            }
          }
        }
      } on SocketException catch (socketException) {
        await _addAnswerFromChatbot(
            message: constants.noInternetMessage, waitForSometime: true);
      } catch (e) {
        await _addAnswerFromChatbot(
            message: constants.errorMessage, waitForSometime: true);

        print('Error occurred in dialogflow message $e');
      }

      yield MessageAddedState(chatList: chatList);
    } else if (event is SendMessageFromChatbotEvent) {
      await _addAnswerFromChatbot(message: event.message, option: event.option);
      yield MessageAddedState(chatList: chatList);
    } else if (event is ChangeChatbotLocale) {
      chatbotLocale = event.locale;
    } else {
      yield InitialState();
    }
  }

  Future<void> _initializeDialogflow() async {
    String _language;

    if (checkLocaleEquality(chatbotLocale, Locale('en', 'UK'))) {
      _language = Language.english;
    } else if (checkLocaleEquality(chatbotLocale, Locale('hi', 'IN'))) {
      _language = Language.hindi;
    } else {
      _language = Language.english;
    }

    AuthGoogle authGoogle =
    await AuthGoogle(fileJson: "assets/services.json").build();
    dialogflow = Dialogflow(authGoogle: authGoogle, language: _language);
  }

  Future<void> _addAnswerFromChatbot(
      {Option option,
        @required String message,
        bool loading = false,
        bool sendMessageToDialogflow = true,
        String action,
        bool waitForSometime = false}) async {
    if (waitForSometime)
      await Future.delayed(constants.messageDurationForCornerCaseMessages);

    if (chatList.length > 0 && chatList[0].loading == true) {
      // for replacing the progress indicator with message
      chatList[0] = Message(
          sender: Sender.chatbot,
          message: message,
          option: option,
          loading: false,
          action: action,
          sendMessageToDialogFlow: sendMessageToDialogflow);
    } else {
      if (loading == true) {
        //the one to be inserted is going to be true
        //wait for some time to remove abruptness

        await Future.delayed(
            constants.durationBeforeRenderingProgressIndicator);
      }
      chatList.insert(
          0,
          Message(
              sender: Sender.chatbot,
              message: message,
              option: option,
              loading: loading));
    }
  }

  Future<void> _sendMessageAccordingly(String actionType) async {

    stateNameInAPIFormat = stateNameInAPIFormat.trim().toLowerCase().replaceAll(' ', '_');
    districtNameInAPIFormat = districtNameInAPIFormat.trim().toLowerCase().replaceAll(' ', '_');

    List<dynamic> dataList = [];

    switch (actionType) {
      case 'oxygen':
        dataList = await _fetchAndDecodeResourceResponse(state: stateNameInAPIFormat, district: districtNameInAPIFormat, resource: 'oxygen');

        dataList.forEach(
              (data) {
            _addFieldIfNotEmpty(
                data,
                {
                  'District'.tr(): 'district',
                  'State'.tr(): 'state',
                  'PhoneNo'.tr(): 'phone_1',
                  'PhoneNo2'.tr(): 'phone_2',
                  'EmailId'.tr(): 'email',
                  'Address'.tr(): 'address',
                  'Title'.tr(): 'title',
                  'SourceLink'.tr(): 'source_link',
                  'Description'.tr(): 'description',
                  'Comment'.tr(): 'comment',
                  'LastVerifiedOn'.tr(): 'last_verified_on',
                  'Type'.tr(): 'resource type',
                },);
          },
        );
        break;
      case 'helplinenumber':
        dataList = await _fetchAndDecodeResourceResponse(state: stateNameInAPIFormat, district: districtNameInAPIFormat, resource: 'helpline');

        dataList.forEach(
              (data) {
            _addFieldIfNotEmpty(data, {
              'District'.tr(): 'district',
              'State'.tr(): 'state',
              'PhoneNo'.tr(): 'phone_1',
              'PhoneNo2'.tr(): 'phone_2',
              'Description'.tr(): 'description',
              'SourceLink'.tr(): 'source_link',
              'EmailId'.tr(): 'email',
              'LastVerifiedOn'.tr(): 'last_verified_on'
            },
                substringFieldName: 'last_verified_on',
                substringEndIndex: 10
            );
          },
        );
        break;
      case 'ambulance':
        dataList = await _fetchAndDecodeResourceResponse(state: stateNameInAPIFormat, district: districtNameInAPIFormat, resource: 'ambulance');

        dataList.forEach(
              (data) {
            _addFieldIfNotEmpty(data, {
              'District'.tr(): 'district',
              'State'.tr(): 'state',
              'PhoneNo'.tr(): 'phone_1',
              'PhoneNo2'.tr(): 'phone_2',
              'EmailId'.tr(): 'email',
              'Comment'.tr(): 'comment',
              'Description'.tr(): 'description',
              'SourceLink'.tr(): 'source_link',
              'Address'.tr(): 'address',
              'Title'.tr(): 'title'
            });
          },
        );
        break;
      case 'hospitalsandbeds':
        dataList = await _fetchAndDecodeResourceResponse(state: stateNameInAPIFormat, district: districtNameInAPIFormat, resource: 'hospital');

        dataList.forEach(
              (data) {
            _addFieldIfNotEmpty(
                data,
                {
                  'District'.tr(): 'district',
                  'State'.tr(): 'state',
                  'PhoneNo'.tr(): 'phone_1',
                  'PhoneNo2'.tr(): 'phone_2',
                  'EmailId'.tr(): 'email',
                  'Address'.tr(): 'address',
                  'Description'.tr(): 'description',
                  'Title'.tr(): 'title',
                  'Comment'.tr(): 'comment',
                  'LastVerifiedOn'.tr(): 'last_verified_on',
                  'Type'.tr(): 'resource type',
                });
          },
        );
        break;
      case 'medicineavailability':
        dataList = await _fetchAndDecodeResourceResponse(state: stateNameInAPIFormat, district: districtNameInAPIFormat, resource: 'medicine');

        dataList.forEach(
              (data) {
            _addFieldIfNotEmpty(
                data,
                {
                  'District'.tr(): 'district',
                  'State'.tr(): 'state',
                  'PhoneNo'.tr(): 'phone_1',
                  'PhoneNo2'.tr(): 'phone_2',
                  'EmailId'.tr(): 'email',
                  'Title'.tr(): 'title',
                  'Description'.tr(): 'description',
                  'Address'.tr(): 'address',
                  'Comment'.tr(): 'comment',
                  'LastVerifiedOn'.tr(): 'last_verified_on',
                  'SourceLink'.tr(): 'source_link',
                });
          },
        );
        break;
      default:
        await _addAnswerFromChatbot(
            message: constants.errorMessage, waitForSometime: true);
    }

    if(dataList.length <= 0) {
      await _addAnswerFromChatbot(
          message: 'DataNotAvailable'.tr(), waitForSometime: true);
    }
  }

  Future<void> _addFieldIfNotEmpty(
      Map data, Map<String, String> keyFieldNameMap,
      {String substringFieldName, int substringEndIndex}) async {
    StringBuffer message = StringBuffer();

    keyFieldNameMap.forEach((key, value) {
      if (data[value] != null && data[value].trim().length != 0) {
        if (substringFieldName == value) {
          assert(substringEndIndex != null);
          message.writeln(
              '$key: ${data[value].toString().substring(0, substringEndIndex)}');
        } else {
          message.writeln('$key: ${data[value].toString()}');
        }
      }
    });

    if (message.isNotEmpty) {
      _addAnswerFromChatbot(message: message.toString());
    }
  }

  Future<List<dynamic>> _fetchAndDecodeResourceResponse({
    @required String state,
    @required String district,
    @required String resource
  }) async {
    
    try {
      Map<String, String> queryParameters = {
        'resource': resource,
        'state': state,
        'district': district,
      };

      var uri = Uri.https(constants.primaryEndpoint, constants.endpointConcatenateString, queryParameters);

      http.Response httpResponse = await http.get(uri);

      var apiResponse = await jsonDecode(httpResponse.body);

      return apiResponse['data'];
    } catch(e) {
      print('Error occurred in fetching data $e');
    }
    return [];
  }
}

abstract class ChatbotState {}

class InitialState extends ChatbotState {}

class ResponseLoadingState extends ChatbotState {}

class ResponseErrorState extends ChatbotState {}

class MessageAddedState extends ChatbotState {
  final List<Message> chatList;

  MessageAddedState({@required this.chatList});
}
