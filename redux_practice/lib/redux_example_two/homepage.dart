import 'dart:developer' as marach show log;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_practice/redux_example_two/customobject_class.dart';
import 'package:redux_practice/redux_example_two/functions.dart';

class ReduxWithOneMalwareExample extends StatelessWidget {
  const ReduxWithOneMalwareExample ({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Store<ApplicationState>(
      reducer, initialState: const ApplicationState.initialState(),
      middleware: [applicationMiddleWare]
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Redux Example2'), centerTitle: true),
      body: StoreProvider(
        store: storage,
        child: Column(
          children: [
            TextButton(
              onPressed: () => storage.dispatch(const LoadUserData()),
              child: const Text('Load Persons')
            ), 
            StoreConnector<ApplicationState, bool>(
              converter: (storage) => storage.state.isLoading,
              builder: (context, isLoading){
                if(isLoading){return const CircularProgressIndicator();}
                else{return const SizedBox.shrink();}
              }
            ),
            StoreConnector<ApplicationState, Iterable<PersonData>?>(
              converter: (storage) => storage.state.fetchedData,
              builder: (context, persons){
                if(persons == null){return const SizedBox.shrink();}
                else{
                  return Expanded(
                    child: ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, listIndex) {
                        final person = persons.elementAt(listIndex);
                        return ListTile(
                          title: Text(person.name), subtitle: Text('${person.age} years old')
                        );
                      }
                    ),
                  );
                }
              }
            )
          ]
        )
      )
    );
  }
}





const apiUrl = 'http://192.168.136.178:5500/redux_practice/api/people.json';


// const apiUrl = 'http://127.0.0.1:5500/redux_practice/api/people.json';