import 'package:financial_calc/screens/compoundInterestCalc.dart';
import 'package:financial_calc/screens/depreciation.dart';
import 'package:financial_calc/screens/emiCalc.dart';
import 'package:financial_calc/screens/irrCalc.dart';
import 'package:financial_calc/screens/mirrCalc.dart';
import 'package:financial_calc/screens/multipleBcRatio.dart';
import 'package:financial_calc/screens/incomeTaxCacl.dart';
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
        title: const Text('FinCalc'),
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
                MaterialPageRoute(builder: (context) => const Irr()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue[200],
                child: const Text('IRR'),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MIRR()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.purpleAccent[200],
                child: const Text('MIRR'),
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
                color: Colors.blueGrey[200],
                child: const Text('Pay Back Period'),
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
                color: Colors.blueGrey[200],
                child: const Text('Income Tax Calculator'),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BcRatio()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.purpleAccent[200],
                child: const Text('BC'),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Depreciation()),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.yellow[200],
                child: const Text('Depreciation'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
