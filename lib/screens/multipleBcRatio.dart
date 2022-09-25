import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BcRatio extends StatefulWidget {
  const BcRatio({Key? key}) : super(key: key);

  @override
  State<BcRatio> createState() => _BcRatioState();
}

class _BcRatioState extends State<BcRatio> {
  int numOfProjects = 3;
  int numOfYears = 5;
  double interest = 0.10;
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  bool isCalculated = false;

  Map cf = <int, Map>{};
  final _formKey = GlobalKey<FormState>();
  final interestController = TextEditingController();

  void calBcRatio() {
    List indCashFlows = [];
    cf.forEach((key, value) {
      double pvCOF = 0.0;
      double pvCIF = 0.0;

      for (int i = 0; i < value.length; i++) {
        // print(cf[key]![i][i]);
        if (double.parse(cf[key]![i]!) < 0) {
          //for calculating PV value of i can be used as power
          pvCOF += double.parse(cf[key]![i]!) / (pow((1 + interest), i));
        } else {
          pvCIF += double.parse(cf[key]![i]!) / (pow((1 + interest), i));
          // print(pvCIF);
        }
      }
      // if ((pvCIF / pvCOF.abs()) >= 1) {
      indCashFlows.add({
        'index': key,
        'cost': pvCOF.abs(),
        'benefit': pvCIF,
        'B/C': (pvCIF / pvCOF.abs())
      });
      // }
      //push cash flows in
      // print('key $key');
    });

    void sortElements() {
      int n = indCashFlows.length;
      for (int i = 1; i < n; i++) {
        for (int j = 0; j < n - i; j++) {
          if (indCashFlows[j]['cost'] > indCashFlows[j + 1]['cost']) {
            var temp = indCashFlows[j];
            indCashFlows[j] = indCashFlows[j + 1];
            indCashFlows[j + 1] = temp;
          }
        }
      }
    }

    sortElements();
    print('after sorting:');
    print(indCashFlows);
    print('select project: ${compareProject(indCashFlows)}');
  }

  int compareProject(indCashFlows) {
    int selectedProject = indCashFlows[0]['index'];
    for (int i = 1; i < indCashFlows.length; i++) {
      double num =
          indCashFlows[i]['benefit'] - indCashFlows[selectedProject]['benefit'];
      double den =
          indCashFlows[i]['cost'] - indCashFlows[selectedProject]['cost'];

      double ratio = num / den;
      // print('num: $num,dem: $den,ratio: $ratio');

      // print(ratio);
      if (ratio > 1) {
        selectedProject = i;
      }
    }

    return selectedProject;
  }

  @override
  Widget build(BuildContext context) {
    // print('BUILd called');
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
              key: Key('123'),
              itemCount: numOfProjects + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == numOfProjects) {
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

                                // interest = 0.10;

                                //calculate IRR
                                calBcRatio();
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
                                      const BcRatio(),
                                ),
                              );
                            },
                            child: Text('Reset'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // setState(() {
                              //   paymentsNum++;
                              // });
                            },
                            child: Text('Add Row'),
                          ),
                        ],
                      ),
                      if (isCalculated)
                        Column(
                          children: [
                            Text('MIRR: '),
                            // Text('NPV: $netPresentValue')
                          ],
                        )
                    ]),
                  );
                } else {
                  return
                      // padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      Container(
                    child: Column(
                      children: [
                        for (int i = 0; i < numOfYears; i++)
                          i != 0
                              ?
                              // print('inside if');
                              TextFormField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter Year ${i} Cash Flow',
                                    suffixIcon: InkWell(
                                      child: Icon(Icons.close),
                                      onTap: () {
                                        // if (paymentsNum > 2) {
                                        //   payments.remove(index);
                                        //   setState(() {
                                        //     paymentsNum--;
                                        //   });
                                        // }
                                      },
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // print(value);
                                    // handleChange(index, value);
                                    if (cf[index] != null) {
                                      // print('inside if');
                                      cf[index][i] = value;
                                      // print(cf);
                                    } else {
                                      // print('inside else');
                                      cf[index] = {};
                                      cf[index][i] = value;
                                      // print(cf);
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter year ${i + 1} cash flow';
                                    } else {
                                      return null;
                                    }
                                  },
                                )
                              : TextFormField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText:
                                        'Enter project ${index + 1} Initial Payment',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // print(value);
                                    // handleChange(index, value);
                                    if (cf[index] != null) {
                                      // print('inside if');
                                      cf[index][i] = value;
                                      // print(cf);
                                    } else {
                                      // print('inside else');
                                      cf[index] = {};
                                      cf[index][i] = value;
                                      // print(cf);
                                    }
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
                                )
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}

getTextWidget(numOfyears, interestController, index, cf) {
  List<Widget> list = [];
  for (int i = 0; i < numOfyears; i++) {
    if (i != 0) {
      // print('inside if');
      list.add(TextFormField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter Year ${i} Cash Flow',
          suffixIcon: InkWell(
            child: Icon(Icons.close),
            onTap: () {
              // if (paymentsNum > 2) {
              //   payments.remove(index);
              //   setState(() {
              //     paymentsNum--;
              //   });
              // }
            },
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          print(value);
          // handleChange(index, value);
          if (cf[index] != null) {
            // print('inside if');
            cf[index][i] = value;
            // print(cf);
          } else {
            // print('inside else');
            cf[index] = {};
            cf[index][i] = value;
            // print(cf);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter year ${i + 1} cash flow';
          } else {
            return null;
          }
        },
      ));
    } else {
      list.add(TextFormField(
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter project ${index + 1} Initial Payment',
          suffixIcon: InkWell(
            child: Icon(Icons.close),
            onTap: () {
              // if (paymentsNum > 2) {
              //   payments.remove(index);
              //   setState(() {
              //     paymentsNum--;
              //   });
              // }
            },
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          print(value);
          // handleChange(index, value);
          if (cf[index] == Null) {
            // print('inside if');
            cf[index][i] = value;
            // print(cf);
          } else {
            // print('inside else');
            cf[index] = {};
            cf[index][i] = value;
            // print(cf);
          }
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
      ));
    }
  }
  return Column(
    children: list,
  );
}
