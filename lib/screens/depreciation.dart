import 'package:flutter/material.dart';

class Depreciation extends StatefulWidget {
  const Depreciation({Key? key}) : super(key: key);

  @override
  State<Depreciation> createState() => _DepreciationState();
}

class _DepreciationState extends State<Depreciation> {
  double rate = 0.0;
  int? years;
  Map calculations = <String, dynamic>{};
  List results = [];
  double initialCost = 0.0;
  double salvageValue = 0.0;
  bool isCalculated = false;

  String dropdownValue = 'Straignt Line Method';
  final drowDownItems = [
    'Straignt Line Method',
    'Declining Balance Method',
    'Best Time To Switch'
  ];

  final _formKey = GlobalKey<FormState>();

  final initialCostController = TextEditingController();
  final rateController = TextEditingController();
  final yearsController = TextEditingController();
  final salvageValueController = TextEditingController(text: '0');

  void straightLineMethod() {
    double initialBookValue = initialCost - salvageValue;
    double initialDepreciation = initialBookValue / years!;
    List tables = [];

    for (int i = 1; i <= years!; i++) {
      if (i == 1) {
        calculations = {
          'year': i,
          'depreciation': initialDepreciation,
          'endBookValue': initialBookValue - initialDepreciation
        };
        tables.add(calculations);
      } else {
        double bookValue = tables[i - 2]['endBookValue'] - initialDepreciation;

        calculations = {
          'year': i,
          'depreciation': double.parse(initialDepreciation.toStringAsFixed(2)),
          'endBookValue': double.parse(bookValue.toStringAsFixed(2))
        };

        tables.add(calculations);
      }
    }
    // print(tables);
    setState(() {
      results = tables;
      isCalculated = true;
    });
  }

  void decliningBalance() {
    Map calculations = <String, dynamic>{};
    List tables = [];
    double initialBookValue = initialCost - salvageValue;
    double initialDepreciation = initialBookValue * rate;

    for (int i = 1; i <= years!; i++) {
      if (i == 1) {
        calculations = {
          'year': i,
          'depreciation': double.parse(initialDepreciation.toStringAsFixed(2)),
          'endBookValue': double.parse(
              (initialBookValue - initialDepreciation).toStringAsFixed(2))
        };
        tables.add(calculations);
      } else {
        print('value of i: $i');
        double depreciation = tables[i - 2]['endBookValue'] * rate;
        double bookValue = tables[i - 2]['endBookValue'] - depreciation;

        calculations = {
          'year': i,
          'depreciation': double.parse(depreciation.toStringAsFixed(2)),
          'endBookValue': double.parse(bookValue.toStringAsFixed(2))
        };

        tables.add(calculations);
      }
    }
    print(tables);
    setState(() {
      results = tables;
      isCalculated = true;
    });
  }

  void bestTimeToSwitch() {
    Map calculations = <String, dynamic>{};
    List tables = [];
    double initialBookValue = initialCost - salvageValue;
    double SLM;
    double DB_Method;
    String stat;
    double BV;
    for (int i = 1; i <= years!; i++) {
      if (i == 1) {
        SLM = initialBookValue / years!;
        DB_Method = initialBookValue * rate;
        stat = DB_Method > SLM ? 'DB_Method' : 'SLM';

        if (stat == 'DB_Method') {
          BV = initialBookValue - DB_Method;
        } else {
          BV = initialBookValue - SLM;
        }

        calculations = {
          'year': i,
          'SLM': double.parse(SLM.toStringAsFixed(2)),
          'DB_Method': double.parse(DB_Method.toStringAsFixed(2)),
          'stat': stat,
          'BV': double.parse(BV.toStringAsFixed(2))
        };
        tables.add(calculations);
      } else {
        SLM = tables[i - 2]['BV'] / (years! - i + 1);
        DB_Method = tables[i - 2]['BV'] * rate;
        stat = DB_Method > SLM ? 'DB_Method' : 'SLM';

        if (stat == 'DB_Method') {
          BV = tables[i - 2]['BV'] - DB_Method;
        } else {
          BV = tables[i - 2]['BV'] - SLM;
        }

        calculations = {
          'year': i,
          'SLM': double.parse(SLM.toStringAsFixed(2)),
          'DB_Method': double.parse(DB_Method.toStringAsFixed(2)),
          'stat': stat,
          'BV': double.parse(BV.toStringAsFixed(2))
        };
        tables.add(calculations);
      }
    }
    print(tables);
    setState(() {
      results = tables;
      isCalculated = true;
    });
  }

  displayResults(results) {
    if (dropdownValue == 'Declining Balance Method') {
      return displayTables(results);
    } else if (dropdownValue == 'Best Time To Switch') {
      return displayBestTimeToSwitchTable(results);
    }
  }

  @override
  void dispose() {
    rateController.dispose();
    initialCostController.dispose();
    salvageValueController.dispose();
    yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('isCalculated: $isCalculated');
    if (dropdownValue == 'Straignt Line Method') {
      return Scaffold(
          appBar: AppBar(
            title: Text('Depriciation'),
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
                        controller: salvageValueController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter Salvage Value',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter salvage value';
                          } else if (double.parse(value) < 0) {
                            return 'Please enter appropriate salvage value';
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
                          labelText: 'Enter Depreciation Years',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please years';
                          } else if (double.parse(value) < 0) {
                            return 'Please enter years';
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
                          // setState(() {
                          print('validated');

                          years = int.parse(yearsController.text);
                          initialCost =
                              double.parse(initialCostController.text);
                          salvageValue =
                              double.parse(salvageValueController.text);
                          //calculate IRR
                          straightLineMethod();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    if (isCalculated) displayTables(results)
                  ],
                ),
              ),
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Depriciation'),
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
                        controller: salvageValueController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter Salvage Value',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter salvage value';
                          } else if (double.parse(value) < 0) {
                            return 'Please enter appropriate salvage value';
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
                          labelText: 'Enter Depreciation Years',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please years';
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
                        controller: rateController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter Depreciation Rate %',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter initial cost';
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
                          // setState(() {
                          print('validated');

                          years = int.parse(yearsController.text);
                          initialCost =
                              double.parse(initialCostController.text);
                          salvageValue =
                              double.parse(salvageValueController.text);
                          rate = double.parse(rateController.text) / 100;
                          //calculate IRR
                          if (dropdownValue == 'Declining Balance Method') {
                            decliningBalance();
                          } else {
                            bestTimeToSwitch();
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    if (isCalculated) displayResults(results)
                  ],
                ),
              ),
            ),
          ));
    }
  }
}

displayTables(tables) {
  return SingleChildScrollView(
    child: DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Year',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Depretiation',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'End Book Value',
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
                Text('${tables[i]['year']}'),
              ),
              DataCell(
                Text('${tables[i]['depreciation']}'),
              ),
              DataCell(
                Text('${tables[i]['endBookValue']}'),
              ),
            ],
          )
      ],
    ),
    scrollDirection: Axis.horizontal,
  );
}

displayBestTimeToSwitchTable(tables) {
  print(tables.length);
  return SingleChildScrollView(
    child: DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Year',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'SLM',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'DB Method',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Stat',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'BV',
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
                Text('${tables[i]['year']}'),
              ),
              DataCell(
                Text('${tables[i]['SLM']}'),
              ),
              DataCell(
                Text('${tables[i]['DB_Method']}'),
              ),
              DataCell(
                Text('${tables[i]['stat']}'),
              ),
              DataCell(
                Text('${tables[i]['BV']}'),
              ),
            ],
          )
      ],
    ),
    scrollDirection: Axis.horizontal,
  );
}
