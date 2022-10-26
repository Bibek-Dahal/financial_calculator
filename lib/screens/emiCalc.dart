
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EmiCalc extends StatefulWidget {
  const EmiCalc({Key? key}) : super(key: key);

  @override
  State<EmiCalc> createState() => _EmiCalcState();
}

class _EmiCalcState extends State<EmiCalc> {
  var loanAmount = "";
  var interestRate = "";
  int years = 0;
  int months = 0;
  var monthlyPayment = "";
  var annualPayment = "";
  var totalInterest = "";
  var totalPayment = "";
  bool isCalculated = false;

  final _formKey = GlobalKey<FormState>();

  final loanAmountController = TextEditingController();
  final interestRateController = TextEditingController();
  final yearsController = TextEditingController();
  final monthController = TextEditingController();

  void calculateEmi() {
    try {
      int period = years * 12 + months;
      double interest = ((double.parse(interestRate) / 100) / 12);
      print('interestRate: $interestRate');
      print('interest: $interest');
      print('period: $period');
      print('months: $months');
      NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

      var beforeFormat = double.parse(((double.parse(loanAmount) * interest) /
              (1 - 1 / pow((1 + interest), period)))
          .toStringAsFixed(2));

      setState(() {
        monthlyPayment = myFormat.format(beforeFormat);

        annualPayment = myFormat
            .format(double.parse((beforeFormat * 12).toStringAsFixed(2)));

        print(myFormat
            .format(double.parse((beforeFormat * period).toStringAsFixed(2))));
        totalPayment = myFormat
            .format(double.parse((beforeFormat * period).toStringAsFixed(2)));

        isCalculated = true;
      });
    } catch (error) {
      print(error);
      print('error generated');
      setState(() {
        monthlyPayment = "0.0";
        annualPayment = "0.0";
      });
    }
  }

  @override
  void dispose() {
    loanAmountController.dispose();
    interestRateController.dispose();
    yearsController.dispose();
    monthController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('EMI'),
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
                    controller: loanAmountController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Loan Amountt',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter loan amount';
                      } else if (double.parse(value) < 1) {
                        return 'Please enter appropriate loan amount';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: interestRateController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Interest Rate %',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter interest rate';
                      } else if (double.parse(value) == 0) {
                        return 'Please enter appropriate interest rate';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: yearsController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Years',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter year';
                      } else if (double.parse(value) == 0) {
                        return 'Please enter appropriate year';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: monthController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Loan Months',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter months';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0 ,0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[ ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // setState(() {
                        loanAmount = loanAmountController.text;
                        interestRate = interestRateController.text;
                        years = int.parse(yearsController.text);
                        months = int.parse(monthController.text);
                        // });
                        calculateEmi();
                      }
                    },
                    child: const Text('Calculate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CBAD6),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      fixedSize: const Size(130,40),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const EmiCalc(),
                                  ),
                                );
                    },
                    child: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CBAD6),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      fixedSize: const Size(130,40),
                    ),
                  ),
                  ]
                  )
            ),
                isCalculated
                    ? const Align(
                        alignment: AlignmentDirectional(-0.9, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            'RESULT',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF0B0A0A),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const Text(''), // Generated code for this Card Widget...
                isCalculated
                    ? Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 0),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                        child: Text(
                                          'Monthly EMI :',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF0B0A0A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$monthlyPayment',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF595F67),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                        child: Text(
                                          'Annual Payement :',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF0B0A0A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$annualPayment',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF595F67),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                        child: Text(
                                          'Total Payement:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFF0B0A0A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$totalPayment',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF595F67),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const Text('')

                // Padding(
                //   padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                //   child: isCalculated
                //       ? Column(children: [
                //           Text('Monthly Payment: $monthlyPayment'),
                //           Text('Annual Payment: $annualPayment'),
                //           Text('Total Payment: $totalPayment'),
                //         ])
                //       : const Text(''),
                // )
              ],
            )),
      ),
    );
  }
}
