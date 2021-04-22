import 'package:covibot/blocs/settings_bloc.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
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
          SettingsSwitch(name: 'DarkTheme'.tr(), onChanged: (bool value) => settingsBloc.add(ToggleThemeEvent())),
          SettingsDropdown(name: 'Language'.tr()),
          SettingsDropdown(name: 'FontSize'.tr()),
          SettingsDropdown(name: 'FontFamily'.tr()),
        ],
      ),
    );
  }
}

class SettingsSwitch extends StatefulWidget {

  final String name;
  final Function(bool value) onChanged ;

  const SettingsSwitch({@required this.name, @required this.onChanged});

  @override
  _SettingsSwitchState createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
        title: Text(widget.name),
        value: _value,
        onChanged: (bool value) {
          widget.onChanged(value);

          setState(() => _value = value == true);
        }
    );
  }
}

class SettingsDropdown extends StatelessWidget {

  final String name;

  const SettingsDropdown({@required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('FontSize'.tr()),
      trailing: DropdownButton(

        onChanged: (option) => print(option),
        items: <DropdownMenuItem>[
          DropdownMenuItem(
            child: Text('20'),
          ),
          DropdownMenuItem(
            child: Text('21'),
          )
        ],
      ),
    );
  }
}
