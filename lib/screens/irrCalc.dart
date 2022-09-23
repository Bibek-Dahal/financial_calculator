import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Irr extends StatefulWidget {
  const Irr({Key? key}) : super(key: key);

  @override
  State<Irr> createState() => _IrrState();
}

class _IrrState extends State<Irr> {
  double currentIRR = 0.0;
  String netPresentValue = "";
  String futureValue = "";
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

  void calculateIRR() {
    List cf = [];
    payments.forEach((key, value) {
      cf.add(double.parse(value));
    });

    const double LOW_RATE = -0.5;
    const double HIGH_RATE = 0.5;
    const double MAX_ITERATION = 1000;
    const double PRECISION_REQ = 0.00000001;
    int i = 0, j = 0;
    double m = 0.0;
    double old = 0.00;
    double new1 = 0.00;
    double oldguessRate = LOW_RATE;
    double newguessRate = LOW_RATE;
    double guessRate = LOW_RATE;
    double lowGuessRate = LOW_RATE;
    double highGuessRate = HIGH_RATE;
    double npv = 0.0;

    double denom = 0.0;
    for (i = 0; i < MAX_ITERATION; i++) {
      npv = 0.00;
      for (j = 0; j < cf.length; j++) {
        // denom = pow((1 + guessRate), j);
        npv = npv + (cf[j] / (pow((1 + guessRate), j)));
      }
      /* Stop checking once the required precision is achieved */
      if ((npv > 0) && (npv < PRECISION_REQ)) break;
      if (old == 0)
        old = npv;
      else
        old = new1;
      new1 = npv;
      if (i > 0) {
        if (old < new1) {
          if (old < 0 && new1 < 0)
            highGuessRate = newguessRate;
          else
            lowGuessRate = newguessRate;
        } else {
          if (old > 0 && new1 > 0)
            lowGuessRate = newguessRate;
          else
            highGuessRate = newguessRate;
        }
      }
      oldguessRate = guessRate;
      guessRate = (lowGuessRate + highGuessRate) / 2;
      newguessRate = guessRate;
    }
    // return guessRate;
    calNPV(cf, (guessRate * 100).toStringAsFixed(3));
  }

  void calNPV(cashFlows, IRR) {
    double netPV = 0;
    for (int j = 0; j < cashFlows.length; j++) {
      netPV += (cashFlows[j]!) / pow(1 + MARR, j);
    }
    print('NetPV: $netPV');
    String beforeFormat = netPV.toStringAsFixed(2);
    setState(() {
      netPresentValue = myFormat.format(double.parse(beforeFormat));
      isCalculated = true;
      currentIRR = double.parse(IRR);
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
        title: const Text('IRR'),
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
                                //calculate IRR
                                calculateIRR();
                              }
                            },
                            child: const Text('Submit'),
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
                            Text(
                                'IRR: ${currentIRR < 0 ? 'Unable to calculate' : currentIRR}%'),
                            Text('NPV: $netPresentValue')
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
                                    print(value);
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
