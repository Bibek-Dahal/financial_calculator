import 'package:flutter/material.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:financial_calc/screens/sensitivitychart.dart';
import 'package:financial_calc/screens/breakevenchart.dart';

class BreakEven extends StatefulWidget {
  const BreakEven({Key? key}) : super(key: key);

  @override
  State<BreakEven> createState() => _BreakEvenState();
}

class _BreakEvenState extends State<BreakEven> {
  double rate = 0.0;
  int years = 0;
  Map calculations = <String, dynamic>{};
  List results = [];
  bool isCalculated = false;
  // double initialCost = 0.0;
  // double salvageValue = 0.0;
  // double savings = 0.0;
  // double expenses = 0.0;
  // double pcin = 0.0;
  // double pcsav = 0.0;
  // double pcexp = 0.0;
  // double pcyear = 0.0;

  double fixedCost = 0.0;
  double variableCost = 0.0;
  double salesPrice = 0.0;
  double breakevenpoint = 0.0;
  double totalcost = 0.0;
  double totalrevenue = 0.0;
  double bepcost = 0.0;

  String bepoint = "";

  String dropdownValue = 'SensitivityAnalysis';
  final drowDownItems = ['SensitivityAnalysis', 'SpiderPlot'];

  final _formKey = GlobalKey<FormState>();
  final fixedCostController = TextEditingController();
  final variableCostController = TextEditingController();
  final salesPriceController = TextEditingController();

  void breakevenpointCalc() {
    List tables = [];
    breakevenpoint = (fixedCost) / (salesPrice - variableCost);
    bepcost = breakevenpoint * salesPrice;
    for (double x = 0;
        x <= breakevenpoint.ceil() * 2;
        x += (breakevenpoint.ceil() / 5)) {
      totalcost = fixedCost + variableCost * x;
      totalrevenue = x * salesPrice;
      calculations = {
        'quantity': double.parse(x.toStringAsFixed(2)),
        'fixedcost': double.parse(fixedCost.toStringAsFixed(2)),
        'totalcost': double.parse(totalcost.toStringAsFixed(2)),
        'totalrevenue': double.parse(totalrevenue.toStringAsFixed(2)),
        'bepcost': double.parse(bepcost.toStringAsFixed(2)),
        'bepoint': double.parse(breakevenpoint.toStringAsFixed(2))
      };
      tables.add(calculations);
    }
    // print(tables);
    setState(() {
      bepoint = breakevenpoint.toStringAsFixed(2);
      results = tables;
      isCalculated = true;
    });
  }

  @override
  void dispose() {
    fixedCostController.dispose();
    variableCostController.dispose();
    salesPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakeven Point'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: fixedCostController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Fixed Cost',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter fixed cost';
                      } else if (double.parse(value) < 0) {
                        return 'Please enter appropriate fixed cost';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: variableCostController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter the variable cost per unit.',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the variable cost.';
                      } else if (double.parse(value) < 0) {
                        return 'Please enter appropriate variable cost';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: salesPriceController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter the sales price per unit',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter sales price.';
                      } else if (double.parse(value) < 0) {
                        return 'Please enter appropriate sales price.';
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
                      fixedCost = double.parse(fixedCostController.text);
                      variableCost = double.parse(variableCostController.text);
                      salesPrice = double.parse(salesPriceController.text);
                      breakevenpointCalc();
                    }
                  },
                  child: const Text('Submit'),
                ),
                (isCalculated)
                    ? ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            fixedCost = double.parse(fixedCostController.text);
                            variableCost =
                                double.parse(variableCostController.text);
                            salesPrice =
                                double.parse(salesPriceController.text);
                            breakevenpointCalc();
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      BreakevenChart(
                                        tables: results,
                                      )),
                            );
                          }
                        },
                        child: const Text('Show breakeven graph'),
                      )
                    : const Text(''),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: isCalculated
                      ? Column(children: [
                          Text('BreakEven Point: $bepoint'),
                        ])
                      : const Text(''),
                )
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
