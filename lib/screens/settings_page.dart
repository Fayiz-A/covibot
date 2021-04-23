import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:covibot/blocs/settings_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsPageTitle'.tr()),
      ),
      body: Column(
        children: [
          SettingsSwitch(
              name: 'DarkTheme'.tr(),
              onChanged: (bool value) => settingsBloc.add(ToggleThemeEvent())),
          // SettingsSwitch(name: 'FontSize'.tr(), onChanged: (bool value) => settingsBloc.add(ChangeFontStyleEvent())),
          SettingsDropdown(
            name: 'FontSize'.tr(),
            onOptionSelected: (option) {
              settingsBloc.add(ChangeFontStyleEvent(fontSize: option));
            },
            dropdownTextValueList: [
              {'20': 20.0},
              {'25': 25.0}
            ],
            defaultValue: 20.0,
          ),
          SettingsDropdown(
            name: 'Language'.tr(),
            onOptionSelected: (option) {
              context.setLocale(option);
              BlocProvider.of<ChatbotBloc>(context)..add(ChangeChatbotLocale(option));
            },
            dropdownTextValueList: [
              {'English': Locale('en', 'UK')},
              {'Hindi': Locale('hi', 'IN')}
            ],
              defaultValue: Locale('en', 'UK')
          ),
        ],
      ),
    );
  }
}

class SettingsSwitch extends StatefulWidget {
  final String name;
  final Function(bool value) onChanged;

  const SettingsSwitch({@required this.name, @required this.onChanged});

  @override
  _SettingsSwitchState createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
        title: Text(
          widget.name,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: _value,
        onChanged: (bool value) {
          widget.onChanged(value);

          setState(() => _value = value == true);
        });
  }
}

class SettingsDropdown extends StatefulWidget {
  final String name;
  final Function(dynamic option)
      onOptionSelected; //it is dynamic from the framework itself
  final List<Map<String, dynamic>> dropdownTextValueList;
  final defaultValue;

  SettingsDropdown(
      {@required this.name,
      @required this.onOptionSelected,
      @required this.dropdownTextValueList,
      @required this.defaultValue});

  @override
  _SettingsDropdownState createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {

  var _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(
        widget.name,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: DropdownButton(
        value: _value,
        onChanged: (option) {
          setState(() {
            _value = option;
          });
          widget.onOptionSelected(option);
        },
        items: widget.dropdownTextValueList.map((textValue) {
          return DropdownMenuItem(
            //map with only one key and one value
            child: Text(textValue.keys.first),
            value: textValue.values.first,
          );
        }).toList(),
      ),
    );
  }
}
