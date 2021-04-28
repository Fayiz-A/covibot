import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:covibot/blocs/settings_bloc.dart';
import 'package:covibot/blocs/shared_preferences_bloc.dart';
import 'package:covibot/classes/message.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:covibot/library_extensions/phone_number_url.dart';
import 'package:covibot/screens/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  TextEditingController queryTextFormFieldController = TextEditingController();

  ChatbotBloc chatBloc;
  SharedPreferencesBloc sharedPreferencesBloc;
  bool _firstTime;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatbotBloc>(context);

    sharedPreferencesBloc = BlocProvider.of<SharedPreferencesBloc>(context);

    SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

    ThemeMode _themeMode;
    double _fontSize;

    sharedPreferencesBloc.stream.listen((state) {
      if (state is InitializedState) {
        sharedPreferencesBloc.add(GetEvent('fontSize'));
        sharedPreferencesBloc.add(GetEvent('darkTheme'));
        sharedPreferencesBloc.add(GetEvent('firstTime'));
      }
      if (state is ValueRetrievedState) {
        var value = state.value;
        String key = state.key;

        if (value != null) {
          if (key == 'fontSize') {
            _fontSize = value;
          } else if (key == 'darkTheme') {
            _themeMode = value == true ? ThemeMode.dark : ThemeMode.light;
          } else if (key == 'firstTime') {
            _firstTime = value;
            if (_firstTime == true) {
              showDisclaimerAlertAfterViewRenders();
            }
          }

          if (_fontSize != null && _themeMode != null) {
            settingsBloc.add(SetInitialValuesEvent(
                fontSize: _fontSize,
                locale: context.locale,
                themeMode: _themeMode));
          }
        } else {
          _fontSize = constants.defaultFontSize;
          _themeMode = constants.defaultThemeMode;

          if (_firstTime == null) {
            _firstTime = true;
            showDisclaimerAlertAfterViewRenders();
          }

          settingsBloc.add(SetInitialValuesEvent(
              fontSize: _fontSize,
              locale: context.locale,
              themeMode: _themeMode));
        }
      }
    });
  }

  showDisclaimerAlertAfterViewRenders() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_firstTime == true) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              scrollable: true,
              title: Text('Disclaimer'),
              content: Text(
                'This app provides data from liferesources.in apis. We shall not be responsible for any kind of losses due to the data provided by this app. \n\nThe data provided by this app for now is only related to India.',
                style: TextStyle(fontSize: 20),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Yes, I Agree'),
                  onPressed: () {
                    sharedPreferencesBloc.add(SaveEvent(
                        type: TypeEnum.boolean,
                        value: false,
                        key: 'firstTime'));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  clearTextBoxAndSendQuery(
      {@required String query,
        String action,
        bool sendMessageToDialogflow = true}) {
    queryTextFormFieldController.clear();

    print('sending permision: $sendMessageToDialogflow');
    chatBloc.add(SendQueryAndYieldMessageEvent(
        query: query,
        action: action,
        sendMessageToDialogFlow: sendMessageToDialogflow));
  }

  @override
  Widget build(BuildContext context) {
    Message _message;

    return Scaffold(
      appBar: AppBar(
        title: Text('CoviBot'.tr()),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.push(context,
                CupertinoPageRoute(builder: (context) => SettingsPage())),
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
                            ChatMessage(message: message, index: index),
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
                              sendMessageToDialogflow:
                              _message.sendMessageToDialogFlow),
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
                              sendMessageToDialogflow:
                              _message.sendMessageToDialogFlow),
                        ),
                      )),
                )),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatefulWidget {
  final Message message;
  final int index;

  ChatMessage({@required this.message, @required this.index});

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  ChatbotBloc chatbotBloc;

  void initState() {
    super.initState();
    chatbotBloc = BlocProvider.of<ChatbotBloc>(context);
  }

  _launchURL(link) async {
    print(link.url);
    if (link != null) {
      try {
        await launch(link.url);
      } catch (e) {
        print(e);
        chatbotBloc
            .add(SendMessageFromChatbotEvent(message: 'URLCannotLaunch'.tr()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool optionPresent = widget.message.option != null;
    Size screenSize = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Material(
            child: InkWell(
              onTap: () => optionPresent
                  ? chatbotBloc.add(SendQueryAndYieldMessageEvent(
                  query: widget.message.option.queryForChatbot,
                  action: widget.message.action,
                  sendMessageToDialogFlow:
                  widget.message.sendMessageToDialogFlow))
                  : null,
              child: Container(
                width: screenSize.width * 0.7,
                color: widget.message.sender == Sender.chatbot
                    ? optionPresent
                    ? Colors.red
                    : Colors.orangeAccent
                    : Colors.greenAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedCrossFade(
                    crossFadeState: widget.message.loading
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: widget.index == 0 &&
                        widget.message.sender == Sender.chatbot
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
                    secondChild: optionPresent
                        ? Linkify(
                      onOpen: (link) async {
                        await _launchURL(link);
                      },
                      linkifiers: [
                        UrlLinkifier(),
                        PhoneNumberLinkifier(),
                        EmailLinkifier(),
                      ],
                      text: optionPresent
                          ? widget.message.option.message
                          : widget.message.message,
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                        : SelectableLinkify(
                      onOpen: (link) async {
                        await _launchURL(link);
                      },
                      linkifiers: [
                        UrlLinkifier(),
                        PhoneNumberLinkifier(),
                        EmailLinkifier(),
                      ],
                      text: optionPresent
                          ? widget.message.option.message
                          : widget.message.message,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
