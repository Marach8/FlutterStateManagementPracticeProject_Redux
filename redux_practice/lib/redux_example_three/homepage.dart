import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_practice/redux_example_three/customclass.dart';
import 'package:redux_practice/redux_example_three/functions.dart';

class ReduxWithTwoMalwaresExample extends StatelessWidget {
  const ReduxWithTwoMalwaresExample ({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Store<ApplicationState>(
      reducer, initialState: const ApplicationState.initialState(),
      middleware: [loadPersonsDataMiddleWare, loadPersonImageMiddleWare]
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
              converter: (storage) => storage.state.sortedfetchedData,
              builder: (context, persons){
                if(persons == null){return const SizedBox.shrink();}
                else{
                  return Expanded(
                    child: ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, listIndex) {
                        final person = persons.elementAt(listIndex);
                        Widget subtitle = Text('${person.age} years old');
                        return ListTile(
                          title: Text(person.name), 
                          subtitle: person.imageData == null? subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subtitle,
                              Image.memory(person.imageData!)
                            ]
                          ),
                          trailing: person.isLoading? const CircularProgressIndicator(): TextButton(
                            onPressed: () => storage.dispatch(LoadImageDataAction(id: person.id)),
                            child: const Text('Load Image')
                          )
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


const apiUrl = 'http://192.168.0.167:5500/redux_practice/api/people.json';