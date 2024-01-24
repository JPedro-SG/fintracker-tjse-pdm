import 'package:FinTracker/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Tracker TJSE',
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          // appBarTheme: AppBarTheme(
          //   backgroundColor: Colors.amber,
          //   titleTextStyle: TextStyle(color: Colors.white)
          // )
          iconTheme: IconThemeData(color: Colors.red[900])),
      home: Home(),
    );
  }
}
