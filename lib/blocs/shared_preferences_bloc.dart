import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TypeEnum {
  boolean,
  int,
  string,
  double
}

abstract class SharedPreferencesEvent {}

class SaveEvent extends SharedPreferencesEvent {
  final TypeEnum type;
  final value;
  final String key;

  SaveEvent({@required this.type, @required this.value, @required this.key});

}

class GetEvent extends SharedPreferencesEvent {
  final String key;

  GetEvent(this.key);
}

class InitializeEvent extends SharedPreferencesEvent {}

class SharedPreferencesBloc extends Bloc<SharedPreferencesEvent, SharedPreferencesState> {
  SharedPreferences prefs;

  SharedPreferencesBloc() : super(InitialState());

  @override
  Stream<SharedPreferencesState> mapEventToState(SharedPreferencesEvent event) async* {

    if(event is InitializeEvent) {
      prefs = await SharedPreferences.getInstance();
      yield InitializedState();
    } else if (event is GetEvent) {
      var value = prefs.get(event.key);

      yield ValueRetrievedState(value, key: event.key);
    } else if(event is SaveEvent) {
      switch(event.type) {
        case TypeEnum.boolean:
          prefs.setBool(event.key, event.value);
          break;
        case TypeEnum.int:
          prefs.setInt(event.key, event.value);
          break;
        case TypeEnum.string:
          prefs.setString(event.key, event.value);
          break;
        case TypeEnum.double:
          prefs.setDouble(event.key, event.value);
          break;
        default: print('What do you want me to set?');
      }

      yield ValueSavedState();
    } else {
      yield InitialState();
    }
  }
}

abstract class SharedPreferencesState {}

class InitialState extends SharedPreferencesState {}

class InitializedState extends SharedPreferencesState {}

class ValueSavedState extends SharedPreferencesState {}

class ValueRetrievedState extends SharedPreferencesState {
  final String key;
  final value;

  ValueRetrievedState(this.value, {@required this.key});
}