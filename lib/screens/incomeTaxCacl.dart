import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TaxCalc extends StatefulWidget {
  const TaxCalc({Key? key}) : super(key: key);

  @override
  State<TaxCalc> createState() => _TaxCalcState();
}

class _TaxCalcState extends State<TaxCalc> {
  var monthlySalary = "";
  // int years = 0;
  // int months = 0;
  var bonus = "";
  var totalSalary = "";
  var totalTax = "";
  var relationship = "";
  bool isCalculated = false;


  String dropdownValue = 'Married';
  final drowDownItems = [
    'Married',
    'Unmarried',
  ];

  final _formKey = GlobalKey<FormState>();

  final salaryController = TextEditingController();
  final taxController = TextEditingController();
  final bonusController = TextEditingController();

void calculateTax() {
  double taxcalc = 0;
    try {
      NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
      double income = ((double.parse(monthlySalary) * 12 + double.parse(bonus)));
      double tsalary = income;
      if (relationship == 'Married'){
      var m = {
        500000.0 : 0.01,
        200000.0: 0.1,
        300000.0: 0.2,
        1000000.0 : 0.3,
        double.maxFinite: 0.36,
      };
    // double taxamount = 0;
     m.forEach((amount, tax) {
      double billAmount = min(income,amount);
      taxcalc += billAmount*tax;
      income -= billAmount;
      if (income<=0){
        return;
      } 
      });
      }
      else{
         var m = {
        600000.0 : 0.01,
        200000.0: 0.1,
        300000.0: 0.2,
        900000.0 : 0.3,
        double.maxFinite: 0.36,
      };
    // double taxamount = 0;
     m.forEach((amount, tax) {
      double billAmount = min(income,amount);
      taxcalc += billAmount*tax;
      income -= billAmount;
      if (income<=0){
        return;
      } 
      });
      }

      setState(() {
        totalSalary = myFormat.format(tsalary);
        totalTax = myFormat.format(taxcalc);
        isCalculated = true;
      });
    } catch (error) {
      setState(() {
        totalSalary = "0.0";
        totalTax = "0.0";
        taxcalc = 0;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Income tax calculator Calculator'),
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
                    controller: salaryController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter the monthly Salary',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the salary';
                      } else if (double.parse(value) < 1) {
                        return 'Please enter appropriate salary';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: TextFormField(
                    controller: bonusController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Bonus',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the bonus';
                      } 
                      else {
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
                      if (_formKey.currentState!.validate()) {
                        monthlySalary = salaryController.text;
                        bonus = bonusController.text;
                        relationship = dropdownValue;
                        calculateTax();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: isCalculated
                      ? Column(children: [
                          Text('Total Salary: $totalSalary'),
                          Text('Tax: $totalTax'),
                        ])
                      : const Text(''),
                )
              ],
            )),
      ),
    );
  }

}
