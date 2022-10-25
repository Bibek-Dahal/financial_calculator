import 'package:financial_calc/screens/compoundInterestCalc.dart';
import 'package:financial_calc/screens/emiCalc.dart';
import 'package:financial_calc/screens/home1.dart';
import 'package:financial_calc/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePageWidget(),
    );
  }
}
