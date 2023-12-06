import 'dart:convert'; import 'dart:io';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:redux_practice/redux_example_three/customclass.dart';
import 'package:redux_practice/redux_example_three/homepage.dart';


void loadPersonsDataMiddleWare(Store<ApplicationState> store, action, NextDispatcher nextDispatch){
  if(action is LoadUserData){
    getPersonData()
      .then((persons) {store.dispatch(SuccessfullUserDataFetch(personData: persons));})
      .catchError((e) => store.dispatch(FailedUserDataFetch(error: e)));
  }
  nextDispatch(action);
}

void loadPersonImageMiddleWare(Store<ApplicationState> store, action, NextDispatcher nextDispatch){
  if(action is LoadImageDataAction){
    final person = store.state.fetchedData?.firstWhere((psn) => psn.id == action.id,);
    if(person != null){
      final bundle =NetworkAssetBundle(Uri.parse(person.url));
      bundle.load(person.url).then((dataBundle) => dataBundle.buffer.asUint8List())
      .then((finalData) => store.dispatch(SuccessfullyLoadedImage(id: person.id, imageData: finalData)));
    }
    getPersonData()
      .then((persons) {store.dispatch(SuccessfullUserDataFetch(personData: persons));})
      .catchError((e) => store.dispatch(FailedUserDataFetch(error: e)));
  }
  nextDispatch(action);
}


ApplicationState reducer(ApplicationState oldState, action){
  if (action is SuccessfullyLoadedImage){
    final person = oldState.fetchedData?.firstWhere((psn) => psn.id == action.id,);
    if (person != null){
      return ApplicationState(
        error: oldState.error, isLoading: false, 
        fetchedData: oldState.fetchedData?.where((psn) => psn.id != person.id)
        .followedBy([person.copyOfPerson(false, action.imageData)])
      );
    } else {return oldState;}
  }
  else if(action is LoadImageDataAction){
    final person = oldState.fetchedData?.firstWhere((psn) => psn.id == action.id,);
    if (person != null){
      return ApplicationState(
        error: oldState.error, isLoading: false, 
        fetchedData: oldState.fetchedData?.where((psn) => psn.id != person.id)
        .followedBy([person.copyOfPerson(true)])
      );
    } else {return oldState;}
  }
  else if(action is LoadUserData){
    return const ApplicationState(error: null, isLoading: true, fetchedData: null);
  } else if(action is SuccessfullUserDataFetch){
    return ApplicationState(error: null, isLoading: false, fetchedData: action.personData);
  } else if(action is FailedUserDataFetch){
    return ApplicationState(error: action.error, isLoading: false, fetchedData: null);
  } 
  return oldState;
}



Future<Iterable<PersonData>> getPersonData() => HttpClient()
  .getUrl(Uri.parse(apiUrl))
  .then((request) => request.close())
  .then((response) => response.transform(utf8.decoder).join())
  .then((string) => json.decode(string) as List<dynamic>)
  .then((list) => list.map((element) => PersonData.fromJson(element)));


// void fetchData() async {
//   final response = await http.get(Uri.parse(apiUrl));

//   if (response.statusCode == 200) {
//     // Decode JSON response
//     final jsonData = json.decode(response.body);
//     // Process the decoded data
//     print(jsonData);
//   } else {
//     // Handle error
//     print('Request failed with status: ${response.statusCode}');
//   }
// }