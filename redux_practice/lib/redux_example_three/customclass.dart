import 'dart:typed_data';
import 'package:flutter/material.dart';

class ReduxExampleThree extends StatelessWidget {
  const ReduxExampleThree({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class PersonData{
  final String name; final int age; final String id, url; final Uint8List? imageData; final bool isLoading;
  PersonData({
    required this.name, required this.id, required this.url,
    required this.age, required this.imageData, required this.isLoading
  });


  PersonData copyOfPerson([bool? imageLoading, Uint8List? dataOfImage])
    => PersonData(
      name: name, id: id, age: age, url: url, imageData: dataOfImage?? imageData, 
      isLoading: imageLoading?? isLoading
    );


  PersonData.fromJson(Map<String, dynamic> json) 
    : name = json['name'] as String, age = json['age'] as int, id = json['id'] as String, 
    url = json['url'] as String, imageData = null, isLoading = false;

  @override
  String toString() => 'Person: ($name, $age years old, id: $id)';
}



@immutable 
abstract class Actions{const Actions();}

@immutable 
class LoadUserData extends Actions{
  const LoadUserData();
}

@immutable 
class SuccessfullUserDataFetch extends Actions{
  final Iterable<PersonData>? personData;
  const SuccessfullUserDataFetch({required this.personData});  
}

@immutable
class FailedUserDataFetch extends Actions{
  final Object error; const FailedUserDataFetch({required this.error});
}


@immutable
class LoadImageDataAction extends Actions{final String id;  const LoadImageDataAction({required this.id});}

@immutable
class SuccessfullyLoadedImage extends Actions{
  final String id; final Uint8List imageData;
  const SuccessfullyLoadedImage({required this.id, required this.imageData}); 
}

@immutable 
class ApplicationState{
  final bool isLoading; final Iterable<PersonData>? fetchedData; final Object? error;
  const ApplicationState({required this.isLoading, required this.fetchedData, required this.error});

  Iterable<PersonData>? get sortedfetchedData => 
  fetchedData?.toList()?..sort((p1, p2) => int.parse(p1.id).compareTo(int.parse(p2.id)));
  
  const ApplicationState.initialState():isLoading = false, fetchedData = null, error = null;
}
