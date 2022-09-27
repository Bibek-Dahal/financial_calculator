import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Pbp extends StatefulWidget {
  const Pbp({Key? key}) : super(key: key);

  @override
  State<Pbp> createState() => _PbpState();
}

class _PbpState extends State<Pbp> {
  String pbperiod = "";
  String dpbperiod = "";
  double MARR = 0.0;
  int paymentsNum = 4;
  bool isCalculated = false;
  final payments = Map<int, String>();
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  final marrController = TextEditingController();

  void handleChange(index, value) {
    payments[index] = value;
    print(payments);
  }

  void calculatePBP() {
    List cashFlows = [];
    payments.forEach((key, value) {
      cashFlows.add(double.parse(value));
    });
    List cumCashFlows = [];
    List disCashFlows = [];
    List disCumCashFlows = [];
    bool isPbpCalculated = false;
    bool isDpbpCalculated = false;
    double disCumCash = 0;
    double disCash = 0;
    double cumCash = 0;

    for (int i = 0; i < cashFlows.length; i++) {
      disCash = (cashFlows[i]!) / pow(1 + MARR, i);
      disCashFlows.add(disCash);
      disCumCash += disCashFlows[i];
      disCumCashFlows.add(disCumCash);
      if (disCumCash >= 0) {
        isDpbpCalculated = true;
        break;
      }
    }

    //calculating PBP
    for (int i = 0; i < cashFlows.length; i++) {
      cumCash += cashFlows[i];
      cumCashFlows.add(cumCash);
      if (cumCash >= 0) {
        isPbpCalculated = true;
        break;
      }
    }

    // print(cumCashFlows);
    // print(disCumCashFlows);
    int n = cumCashFlows.length - 2;
    double I = cumCashFlows[n];
    double cf = cashFlows[n + 1];
    int p = disCumCashFlows.length - 2;
    double J = disCumCashFlows[p];
    double dcf = disCashFlows[p + 1];
    var pbp = n + (-I) / cf;
    var dpbp = p + (-J) / dcf;
    // print(isCalculated);

    setState(() {
      isCalculated = true;
      if (isPbpCalculated == true) {
        pbperiod = pbp.toStringAsFixed(2);
      }
      else {
        pbperiod = myFormat.format(double.infinity);
      }
      if (isDpbpCalculated == true) {
        dpbperiod = dpbp.toStringAsFixed(2);
      } else {
        dpbperiod =myFormat.format(double.infinity);
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    marrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Pay Back Period'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: ListView.builder(
              itemCount: paymentsNum + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == paymentsNum) {
                  return Padding(
                    padding: EdgeInsets.all(2),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                // setState(() {
                                print('validated');

                                MARR = double.parse(marrController.text) / 100;
                                //calculate PBP
                                calculatePBP();
                              }
                            },
                            child: const Text('Submit'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const Pbp(),
                                ),
                              );
                            },
                            child: Text('Reset'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                paymentsNum++;
                              });
                            },
                            child: Text('Add Row'),
                          ),
                        ],
                      ),
                      if (isCalculated)
                        Column(
                          children: [
                            Text('PayBack Period: ${pbperiod}years'),
                            Text('Discounted PayBack Period: ${dpbperiod}years')
                          ],
                        )
                    ]),
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: index != 0
                          ? TextFormField(
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter Cash Flow',
                                suffixIcon: InkWell(
                                  child: Icon(Icons.close),
                                  onTap: () {
                                    if (paymentsNum > 2) {
                                      payments.remove(index);
                                      setState(() {
                                        paymentsNum--;
                                      });
                                    }
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                print(value);
                                handleChange(index, value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter cash flow';
                                } else {
                                  return null;
                                }
                              },
                            )
                          : Column(
                              children: [
                                TextFormField(
                                  controller: marrController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter MARR %',
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter MARR';
                                    } else if (double.parse(value) < 0) {
                                      return 'MARR should be greater 0';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter Initial Payment',
                                    suffixIcon: InkWell(
                                      child: Icon(Icons.close),
                                      onTap: () {
                                        if (paymentsNum > 2) {
                                          payments.remove(index);
                                          setState(() {
                                            paymentsNum--;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // print(value);
                                    handleChange(index, value);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter initial payment';
                                    } else if (double.parse(value) > 0) {
                                      return 'initial payment should be less then 0';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ));
                }
              }),
        ),
      ),
    );
  }
}
