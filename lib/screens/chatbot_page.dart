import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:covibot/blocs/settings_bloc.dart';
import 'package:covibot/blocs/shared_preferences_bloc.dart';
import 'package:covibot/classes/message.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:covibot/screens/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  TextEditingController queryTextFormFieldController = TextEditingController();

  ChatbotBloc chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatbotBloc>(context);

    SharedPreferencesBloc sharedPreferencesBloc = BlocProvider.of<SharedPreferencesBloc>(context);

    SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

    ThemeMode _themeMode;
    double _fontSize;

    sharedPreferencesBloc.stream.listen((state) {
      if(state is InitializedState) {
        sharedPreferencesBloc.add(GetEvent('fontSize'));
        sharedPreferencesBloc.add(GetEvent('darkTheme'));
      }
      if(state is ValueRetrievedState) {
        var value = state.value;

        if(value != null) {
          if(value.runtimeType == double) {
            _fontSize = value;
          } else if(value.runtimeType == bool) {
            _themeMode = value == true ? ThemeMode.dark:ThemeMode.light;
          }
          if(_fontSize != null && _themeMode != null) {

            settingsBloc.add(SetInitialValuesEvent(
                fontSize: _fontSize,
                locale: context.locale,
                themeMode: _themeMode
            ));
          }
        } else {
          _fontSize = constants.defaultFontSize;
          _themeMode = constants.defaultThemeMode;

          settingsBloc.add(SetInitialValuesEvent(
              fontSize: _fontSize,
              locale: context.locale,
              themeMode: _themeMode
          ));
        }
      }
    });
  }

  clearTextBoxAndSendQuery({@required String query, String action, bool sendMessageToDialogflow = true}) {
    queryTextFormFieldController.clear();

    print('sending permision: $sendMessageToDialogflow');
    chatBloc.add(SendQueryAndYieldMessageEvent(query: query, action: action, sendMessageToDialogFlow: sendMessageToDialogflow));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Message _message;

    return Scaffold(
      appBar: AppBar(
        title: Text('CoviBot'.tr()),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SettingsPage())),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: BlocBuilder<ChatbotBloc, ChatbotState>(
                builder: (BuildContext context, ChatbotState state) {
                  if (state is MessageAddedState) {
                    List<Message> chatList = state.chatList;
                    _message = chatList[0];

                    return ListView.builder(
                        reverse: true,
                        itemCount: chatList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Message message = chatList[index];

                          bool chatbotSender = message.sender == Sender.chatbot;

                          bool optionPresent = message.option != null;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: chatbotSender
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  child: chatbotSender
                                      ? Icon(Icons.computer)
                                      : Icon(Icons.person),
                                  backgroundColor: Colors.black,
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                      child: GestureDetector(
                                        onTap: () => optionPresent
                                            ? clearTextBoxAndSendQuery(
                                            query:
                                            message.option.queryForChatbot,
                                            action: message.action,
                                            sendMessageToDialogflow: message.sendMessageToDialogFlow
                                        )
                                            : null,
                                        child: Container(
                                          width: screenSize.width * 0.7,
                                          color: chatbotSender
                                              ? optionPresent
                                              ? Colors.red
                                              : Colors.orangeAccent
                                              : Colors.greenAccent,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AnimatedCrossFade(

                                              crossFadeState: message.loading
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                              duration: index == 0 &&
                                                  message.sender ==
                                                      Sender.chatbot
                                                  ? constants
                                                  .fadeDurationBetweenProgressIndicatorAndMessage
                                                  : Duration(microseconds: 1),
                                              firstChild: Align(
                                                alignment: Alignment.centerLeft,
                                                child: SizedBox(
                                                  // TODO: Remove this hardcoded value
                                                  width: 40,
                                                  height: 40,
                                                  child: SpinKitThreeBounce(
                                                    //TODO: Remove this hardcoded value
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              secondChild: Text(
                                                optionPresent
                                                    ? chatList[index]
                                                    .option
                                                    .queryForChatbot
                                                    : chatList[index].message,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
          Divider(
            thickness: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    child: TextFormField(
                      onFieldSubmitted: (String query) =>
                          clearTextBoxAndSendQuery(
                            query: query,
                            action: _message.action,
                            sendMessageToDialogflow: _message.sendMessageToDialogFlow
                          ),
                      //query from text controller will also work fine
                      style: Theme.of(context).textTheme.bodyText1,
                      autocorrect: false,
                      decoration: InputDecoration(
                          hintText: 'Enter Your Query Here',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.red,
                                  style: BorderStyle.solid),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                      controller: queryTextFormFieldController,
                    ),
                  ),
                ),
                trailing: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: ClipOval(
                      child: Tooltip(
                        message: 'Send',
                        preferBelow: false,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          iconSize: 30.0,
                          onPressed: () => clearTextBoxAndSendQuery(
                            query: queryTextFormFieldController.text,
                            action: _message.action,
                            sendMessageToDialogflow: _message.sendMessageToDialogFlow
                          ),
                        ),
                      )),
                )),
          ),
        ],
      ),
    );
  }
}
