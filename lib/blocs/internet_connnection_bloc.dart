import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

enum InternetConnectionEvent { checkInternetConnection }

enum InternetConnectionState { online, offline, error, initial }

class InternetConnectionBloc extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  InternetConnectionBloc() : super(InternetConnectionState.initial);

  @override
  Stream<InternetConnectionState> mapEventToState(InternetConnectionEvent event) async* {
    if(event == InternetConnectionEvent.checkInternetConnection) {
      yield* _checkConnectivity();
    }
  }

  Stream<InternetConnectionState> _checkConnectivity() async* {
    try {
      //TODO: change this url to some other url than google.com as it doesn't work in China
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        yield InternetConnectionState.online;
      }
    } on SocketException catch (_) {
      yield InternetConnectionState.offline;
    } catch (_) {
      yield InternetConnectionState.error;
    }
  }
}
