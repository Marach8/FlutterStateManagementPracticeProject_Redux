import 'dart:convert'; import 'dart:io';
import 'dart:developer' as marach show log;
import 'package:redux/redux.dart';
import 'package:redux_practice/redux_example_two/customobject_class.dart';
import 'package:redux_practice/redux_example_two/homepage.dart';
import 'package:http/http.dart' as http;

void applicationMiddleWare(Store<ApplicationState> store, action, NextDispatcher nextDispatch){
  switch (action){
    case LoadUserData: {
      getPersonData()
      .then((persons) => store.dispatch(SuccessfullUserDataFetch(personData: persons)))
      .catchError((e) => store.dispatch(FailedUserDataFetch(error: e)));
    }
  }
  nextDispatch(action);
}



ApplicationState reducer(ApplicationState oldState, action){
  switch (action){
    case LoadUserData: return const ApplicationState(isLoading: true, error: null, fetchedData: null);
    case SuccessfullUserDataFetch: return ApplicationState(isLoading: false, error: null, fetchedData: action.personData);
    case FailedUserDataFetch: return ApplicationState(isLoading: false, error: action.error, fetchedData: null);
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