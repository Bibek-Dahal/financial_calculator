import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:intl/intl.dart';

class compIntCalc extends StatefulWidget {
  const compIntCalc({Key? key}) : super(key: key);

  @override
  State<compIntCalc> createState() => _compIntCalcState();
}

class _compIntCalcState extends State<compIntCalc> {
  double principalAmt = 0.0;
  double monthlyDeposit = 0.0;
  int period = 0;
  double annualInterestRate = 0.0;
  String compounding = "";
  String totalPrincipal = "";
  String interestAmount = "";
  String maturityValue = "";
  bool isCalculated = false;

  String dropdownValue = 'Annually';
  final drowDownItems = [
    'Annually',
    'Semiannually',
    'Quarterly',
    'Monthly',
    'Weekly',
    'Daily'
  ];

  final _formKey = GlobalKey<FormState>();
  final principalAmtController = TextEditingController();
  final monthlyDepositController = TextEditingController();
  final periodController = TextEditingController();
  final compoundingController = TextEditingController();
  final annualInterestRateController = TextEditingController();
  final compoundingAmtController = TextEditingController();

  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  void calculateCompInt() {
    try {
      var i = {
        'Daily': (annualInterestRate / 100) / 365,
        'Weekly': (annualInterestRate / 100) / 52,
        'Monthly': (annualInterestRate / 100) / 12,
        'Quarterly': (annualInterestRate / 100) / 4,
        'Semiannually': (annualInterestRate / 100) / 2,
        'Annually': annualInterestRate / 100
      };

      var m = {
        'Daily': 365,
        'Weekly': 52,
        'Monthly': 12,
        'Quarterly': 4,
        'Semiannually': 2,
        'Annually': 1
      };

      print(m[compounding]);
      print(i[compounding]);
      var fvPrincipal =
          principalAmt * (pow((1 + i[compounding]!), period * m[compounding]!));
      print('fvPrincipal: $fvPrincipal');

      var fvAnnuity = ((monthlyDeposit * 12) / m[compounding]!) *
          ((pow((1 + i[compounding]!), m[compounding]!) - 1) / i[compounding]!);
      print('fvannuity $fvAnnuity');

      setState(() {
        maturityValue = myFormat
            .format(double.parse((fvPrincipal + fvAnnuity).toStringAsFixed(2)));
        totalPrincipal = myFormat.format(double.parse(
            (principalAmt + period * 12 * monthlyDeposit).toStringAsFixed(2)));
        interestAmount = ((fvPrincipal + fvAnnuity) -
                (principalAmt + period * 12 * monthlyDeposit))
            .toStringAsFixed(2);

        isCalculated = true;
      });
    } catch (error) {
      print(error);
      print('error occour');
    }
  }

  @override
  void dispose() {
    principalAmtController.dispose();
    monthlyDepositController.dispose();
    periodController.dispose();
    compoundingController.dispose();
    annualInterestRateController.dispose();
    compoundingAmtController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('CIC'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: principalAmtController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Principal Amountt',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter princilap amount';
                      } else if (double.parse(value) < 0) {
                        return 'Please enter appropriate princilap amount';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: monthlyDepositController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Monthly Deposite',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter monthly deposite';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: annualInterestRateController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Annual Interest Rate %',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter annual interest rate';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: periodController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Periods(years)',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter periods(years)';
                      } else if (double.parse(value) == 0) {
                        return 'Please enter appropriate period';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: DropdownButtonFormField(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: drowDownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          principalAmt =
                              double.parse(principalAmtController.text);
                          monthlyDeposit =
                              double.parse(monthlyDepositController.text);
                          period = int.parse(periodController.text);
                          annualInterestRate =
                              double.parse(annualInterestRateController.text);
                          compounding = dropdownValue;
                        });
                        calculateCompInt();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: isCalculated
                      ? Column(children: [
                          Text('Maturity Value: $maturityValue'),
                          Text('Total Principal: $totalPrincipal'),
                          Text('Interest Amount: $interestAmount'),
                        ])
                      : const Text(''),
                )
              ],
            )),
      ),
    );
  }
}
