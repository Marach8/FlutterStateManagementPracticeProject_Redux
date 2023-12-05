import 'package:flutter/material.dart';

class PersonData{
  final String name; final int age;
  PersonData({required this.name, required this.age});

  PersonData.fromJson(Map<String, dynamic> json) : name = json['name'] as String, age = json['age'] as int;

  @override
  String toString() => 'Person: ($name, $age years old)';
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
  final Object error;
  const FailedUserDataFetch({required this.error});
}

@immutable 
class ApplicationState{
  final bool isLoading; final Iterable<PersonData>? fetchedData; final Object? error;
  const ApplicationState({required this.isLoading, required this.fetchedData, required this.error});
  
  const ApplicationState.initialState():isLoading = false, fetchedData = null, error = null;
}
