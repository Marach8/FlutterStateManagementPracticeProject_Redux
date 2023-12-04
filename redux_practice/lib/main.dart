import 'package:flutter/material.dart';
import 'package:redux_practice/redux_example_one/homepage.dart';
import 'package:redux_practice/redux_example_two/homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
        useMaterial3: true
      ),
      home: const ReduxWithOneMalwareExample ()
    );
  }
}
