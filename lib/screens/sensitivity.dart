import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:financial_calc/screens/sensitivitychart.dart';

class Sensitivity extends StatefulWidget {
  const Sensitivity({Key? key}) : super(key: key);

  @override
  State<Sensitivity> createState() => _SensitivityState();
}

class _SensitivityState extends State<Sensitivity> {
  double rate = 0.0;
  int years = 0;
  Map calculations = <String, dynamic>{};
  List results = [];
  double initialCost = 0.0;
  double salvageValue = 0.0;
  double savings = 0.0;
  double expenses = 0.0;
  bool isCalculated = false;
  double pcin = 0.0;
  double pcsav = 0.0;
  double pcexp = 0.0;
  double pcyear = 0.0;
  String pcininvestment = "";
  String pcinsavings = "";
  String pcinexpenses = "";
 

  String dropdownValue = 'SensitivityAnalysis';
  final drowDownItems = ['SensitivityAnalysis', 'SpiderPlot'];

  final _formKey = GlobalKey<FormState>();
  final initialCostController = TextEditingController();
  final savingsController = TextEditingController();
  final marrController = TextEditingController();
  final yearsController = TextEditingController();
  final expensesController = TextEditingController();

  void sensitivitycalc() {
    pcin = ((((savings - expenses) * (1 - 1 / pow((1 + rate), years)) / rate) /initialCost) -1)*100;
    pcsav = -((((initialCost * rate) / (1 - 1 / pow((1 + rate), years)) + expenses) / savings) - 1)*100;
    pcexp = -((((initialCost * rate) / (1 - 1 / pow((1 + rate), years)) - savings) / expenses) + 1)*100;
    setState(() {
      pcininvestment = pcin.toStringAsFixed(2);
      pcinsavings = pcsav.toStringAsFixed(2);
      pcinexpenses = pcexp.toStringAsFixed(2);

      isCalculated = true;
    });

  }

  void spiderplot() {
    List tables = [];
    for (double x = -0.4; x <= 0.4; x += 0.1) {
      pcin = (-initialCost) * (1 + x) + ((savings - expenses) * (1 - 1 / pow((1 + rate), years)) / rate);
      pcsav = (-initialCost) + ((savings * (1 + x) - expenses) * (1 - 1 / pow((1 + rate), years)) / rate);
      pcexp = (-initialCost) + ((savings - expenses * (1 + x)) * (1 - 1 / pow((1 + rate), years)) / rate);
      pcyear = (-initialCost) + ((savings - expenses) * (1 - 1 / pow((1 + rate), years * (1 + x))) / rate);

      calculations = {
        'interestchange': double.parse(x.toStringAsFixed(2)),
        'investmentchange': double.parse(pcin.toStringAsFixed(2)),
        'savingschange': double.parse(pcsav.toStringAsFixed(2)),
        'expenseschange': double.parse(pcexp.toStringAsFixed(2)),
        'yearschange': double.parse(pcyear.toStringAsFixed(2)),
      };
      tables.add(calculations);
    }
    setState(() {
      results = tables;
      isCalculated = true;
    });
    ;
  }


  @override
  void dispose() {
    marrController.dispose();
    initialCostController.dispose();
    savingsController.dispose();
    expensesController.dispose();
    yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sensitivity Analysis'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
              child: ListView(
                children: [
                  DropdownButtonFormField(
                    isExpanded: true,
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;

                        isCalculated = false;
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
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                    child: TextFormField(
                      controller: initialCostController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter Initial Cost',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter initial cost';
                        } else if (double.parse(value) < 0) {
                          return 'Please enter appropriate cost';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                    child: TextFormField(
                      controller: expensesController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter the annual expenses',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter annual expenses.';
                        } else if (double.parse(value) < 0) {
                          return 'Please enter appropriate annual expenses';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                    child: TextFormField(
                      controller: savingsController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter the annual savings',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter annual savings.';
                        } else if (double.parse(value) < 0) {
                          return 'Please enter appropriate annual savings';
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
                        labelText: 'Enter the number of Years',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter years';
                        } else if (double.parse(value) < 0) {
                          return 'Please enter years';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                    child: TextFormField(
                      controller: marrController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter Marr %',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Marr';
                        } else if (double.parse(value) < 0) {
                          return 'Please enter appropriate %';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {

                        years = int.parse(yearsController.text);
                        initialCost = double.parse(initialCostController.text);
                        savings = double.parse(savingsController.text);
                        expenses = double.parse(expensesController.text);
                        rate = double.parse(marrController.text) / 100;
                      
                        spiderplot();
                        sensitivitycalc();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  (isCalculated && dropdownValue == 'SpiderPlot')?ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        years = int.parse(yearsController.text);
                        initialCost = double.parse(initialCostController.text);
                        savings = double.parse(savingsController.text);
                        expenses = double.parse(expensesController.text);
                        rate = double.parse(marrController.text) / 100;
                        spiderplot();
                        Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => SensitivityChart(
                                tables: results,
                              )),
                            );
                      }
                    },
                    child: const Text('Show spider plot graph'),
                  ):const Text(''),
                  (isCalculated)?(dropdownValue == 'SensitivityAnalysis')?
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: Column(children: [
                              Text('Capital Investments: $pcininvestment%'),
                              Text('Savings: $pcinsavings%'),
                              Text('Exepnses: $pcinexpenses%'),
                            ])
                    ):displayTables(results): const Text(''),

                ],
              ),
            ),
          ),
        ),
        );
  }
}

displayTables(tables) {
  return SingleChildScrollView(
    child: DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              '% change in factor',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Capital Investments',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Annual Savings',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Annual Expenses',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Years',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: <DataRow>[
        for (int i = 0; i < tables.length; i++)
          DataRow(
            cells: <DataCell>[
              DataCell(
                Text('${tables[i]['interestchange']}'),
              ),
              DataCell(
                Text('${tables[i]['investmentchange']}'),
              ),
              DataCell(
                Text('${tables[i]['savingschange']}'),
              ),
              DataCell(
                Text('${tables[i]['expenseschange']}'),
              ),
              DataCell(
                Text('${tables[i]['yearschange']}'),
              ),
            ],
          )
      ],
    ),
    scrollDirection: Axis.horizontal,
  );
}
