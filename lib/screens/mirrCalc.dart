import 'dart:math';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MIRR extends StatefulWidget {
  const MIRR({Key? key}) : super(key: key);

  @override
  State<MIRR> createState() => _MIRRState();
}

class _MIRRState extends State<MIRR> {
  double mirr = 0.0;
  double interest = 0.0;
  double pvCOF = 0.0;
  double fvCIF = 0.0;
  int paymentsNum = 5;
  bool isCalculated = false;
  final payments = Map<int, String>();
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  final _formKey = GlobalKey<FormState>();
  final interestController = TextEditingController();

  void handleChange(index, value) {
    payments[index] = value;

    print(payments);
  }

  void calMIRR() {
    pvCOF = 0.0;
    fvCIF = 0.0;
    List cf = [];
    payments.forEach((key, value) {
      cf.add(double.parse(value));
    });

    for (int i = 0; i < cf.length; i++) {
      if (cf[i] < 0) {
        //for calculating PV value of i can be used as power
        pvCOF += cf[i] / (pow((1 + interest), i));
      } else {
        //for calculating i value of i cant ba used as power of i

        fvCIF += cf[i] * (pow((1 + interest), cf.length - 1 - i));
      }
    }

    print('pvCOF: ${pvCOF.abs()}');
    print('fvCIF: $fvCIF');

    mirr = (pow(fvCIF / pvCOF.abs(), 1 / (cf.length - 1)) - 1);

    setState(() {
      mirr = mirr;
      isCalculated = true;
    });

    // print('MIRR: ${(mirr * 100).toStringAsFixed(2)}');
    print(
        '${mirr * 100 == -100.00 ? 'Error' : (mirr * 100).toStringAsFixed(2)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('MIRR'),
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

                                interest =
                                    double.parse(interestController.text) / 100;
                                //calculate IRR
                                calMIRR();
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
                                      const MIRR(),
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
                            Text(
                                'MIRR: ${mirr * 100 == -100.00 ? 'Error' : (mirr * 100).toStringAsFixed(2)}%'),
                            // Text('NPV: $netPresentValue')
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
                                  controller: interestController,
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
