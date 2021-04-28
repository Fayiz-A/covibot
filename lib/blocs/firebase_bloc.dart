import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FetchType {
  document
}

abstract class FirebaseEvent {}

class FirebaseUpdateFieldEvent extends FirebaseEvent {
  final String collection;
  final String document;
  final Map<String, dynamic> updateMap;

  FirebaseUpdateFieldEvent({@required this.collection, @required this.document, @required this.updateMap});

}

class FirebaseGetEvent extends FirebaseEvent {
  final String collection;
  final String document;
  final FetchType fetchType;
  
  FirebaseGetEvent({@required this.collection, @required this.document, @required this.fetchType});
}

class FirebaseInitializeEvent extends FirebaseEvent {
  final bool initialized;

  FirebaseInitializeEvent({@required this.initialized});
}

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {

  FirebaseBloc() : super(InitialState());

  @override
  Stream<FirebaseState> mapEventToState(FirebaseEvent event) async* {

    if(event is FirebaseInitializeEvent) {
      yield FirebaseInitializedState(initialized: event.initialized);
    } else if (event is FirebaseGetEvent) {
      // To be used in cases like future builder where the realtime value is not needed
      try {
        DocumentSnapshot data;

        CollectionReference collectionReference = FirebaseFirestore.instance.collection(event.collection);

        switch(event.fetchType) {
          case FetchType.document:

            data = await collectionReference.doc(event.document).get();

            break;
          default: print('What do you wanna fetch???');
        }
        print(data.data());
        yield FirebaseValueRetrievedState(data: data);
      } catch(e) {
        print(e);
      }

    } else if(event is FirebaseUpdateFieldEvent) {
      try {
        CollectionReference collectionReference = FirebaseFirestore.instance.collection(event.collection);

        await collectionReference.doc(event.document).update(event.updateMap);
        yield FirebaseValueSavedState();
      } catch(e) {
        print(e);
      }
    } else {
      yield InitialState();
    }
  }
}

abstract class FirebaseState {}

class InitialState extends FirebaseState {}

class FirebaseInitializedState extends FirebaseState {
  final bool initialized;
  
  FirebaseInitializedState({@required this.initialized});
}

class FirebaseValueSavedState extends FirebaseState {}

class FirebaseValueRetrievedState extends FirebaseState {
  final data;

  FirebaseValueRetrievedState({@required this.data,});
}