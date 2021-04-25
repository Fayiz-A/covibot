import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:covibot/blocs/settings_bloc.dart';
import 'package:covibot/blocs/shared_preferences_bloc.dart';
import 'package:covibot/classes/message.dart';
import 'package:covibot/constants.dart' as constants;
import 'package:covibot/screens/chatbot_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'UK'), Locale('hi', 'IN')],
      path: 'assets/lang',
      saveLocale: true,
      fallbackLocale: Locale('en', 'UK'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale locale = context.locale;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
          SharedPreferencesBloc()..add(InitializeEvent()),
        ),
        BlocProvider(
            create: (BuildContext context) => ChatbotBloc()
              ..add(ChangeChatbotLocale(locale))
              ..add(SendMessageFromChatbotEvent(
                message: constants.initialMessageFromChatbot.tr(),
              ))
              ..add(SendMessageFromChatbotEvent(
                  message: '',
                  option: Option(
                      message: 'Plasma'.tr(),
                      queryForChatbot: 'plasma')))
              ..add(SendMessageFromChatbotEvent(
                  message: '',
                  option: Option(
                      message: 'Oxygen'.tr(),
                      queryForChatbot: 'oxygen')))
              ..add(SendMessageFromChatbotEvent(
                  message: '',
                  option: Option(
                      message: 'HelplineNumber'.tr(),
                      queryForChatbot: 'helpline number')))
              ..add(SendMessageFromChatbotEvent(
                  message: '',
                  option: Option(
                      message: 'Ambulance'.tr(),
                      queryForChatbot: 'ambulance')))
              ..add(SendMessageFromChatbotEvent(
                  message: '',
                  option: Option(
                      message: 'Hospitals'.tr(),
                      queryForChatbot: 'hospitals and beds')))
              ..add(SendMessageFromChatbotEvent(
                  message: '',
                  option: Option(
                      message: 'MedicineAvailability'.tr(),
                      queryForChatbot: 'medicine availability')))

        ),
        BlocProvider(
          create: (BuildContext context) => SettingsBloc()
            ..add(SetInitialValuesEvent(
                themeMode: ThemeMode.dark,
                fontSize: 20.0,
                locale: Locale('en', 'UK'))),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (BuildContext context, SettingsState state) {
            return MaterialApp(
              title: 'CoviBot',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              themeMode: state.themeMode,
              theme: ThemeData.light().copyWith(
                  primaryColor: Colors.red,
                  splashFactory: InkRipple.splashFactory,
                  brightness: Brightness.light,
                  textTheme: ThemeData.light().textTheme.copyWith(
                    bodyText1: ThemeData.light()
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: state.fontSize),
                  ),
                  tooltipTheme: TooltipThemeData(
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.black.withOpacity(0.7),
                    ),
                  )),
              darkTheme: ThemeData.dark().copyWith(
                  primaryColor: Colors.red,
                  splashFactory: InkRipple.splashFactory,
                  brightness: Brightness.dark,
                  textTheme: ThemeData.dark().textTheme.copyWith(
                    bodyText1: ThemeData.dark()
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: state.fontSize),
                  ),
                  tooltipTheme: TooltipThemeData(
                    textStyle: Theme.of(context).textTheme.bodyText1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )),
              home: SafeArea(top: false, child: ChatbotPage()),
            );
          }),
    );
  }
}
