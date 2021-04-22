import 'package:covibot/blocs/settings_bloc.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsPageTitle'.tr()),
      ),
      body: Column(
        children: [
          SwitchListTile.adaptive(
              title: Text('DarkTheme'.tr()),
              value: true,
              onChanged: (bool value) {}
          ),
          SettingsDropdown(name: 'Language'.tr()),
          SettingsDropdown(name: 'FontSize'.tr()),
          SettingsDropdown(name: 'FontFamily'.tr()),
          ListTile(title: Text('Testing theme'), onTap: () => BlocProvider.of<SettingsBloc>(context)..add(ToggleThemeEvent()),),
        ],
      ),
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
