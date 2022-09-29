import 'package:financial_calc/screens/compoundInterestCalc.dart';
import 'package:financial_calc/screens/emiCalc.dart';
import 'package:financial_calc/screens/incomeTaxCacl.dart';
import 'package:financial_calc/screens/sensitivity.dart';
import 'package:financial_calc/screens/sensitivitychart.dart';
import 'package:flutter/material.dart';
import 'package:financial_calc/screens/payBackCacl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('EMI'),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmiCalc()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[200],
                child: const Text('EMI Calculator'),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const compIntCalc()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.orange[200],
                child: const Text('Compound Interest'),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaxCalc()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Color.fromARGB(255, 203, 128, 128),
                child: const Text('Income Tax Calculator'),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pbp()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Color.fromARGB(255, 165, 8, 218),
                child: const Text('Pay Back Period Calculator'),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Sensitivity()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Color.fromARGB(255, 17, 253, 206),
                child: const Text('Sensitivity'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
