import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SensitivityChart extends StatefulWidget {
  final List tables;
  const SensitivityChart({
    Key? key,
    required this.tables,
  }) : super(key: key);
  @override
  State<SensitivityChart> createState() => _SensitivityChartState();
}

class _SensitivityChartState extends State<SensitivityChart> {
  late List<SalesData> _chartData = [];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Sensitivity Analysis SpiderPlot'),
            ),
            body: SfCartesianChart(
              // title: ChartTitle(text: 'Sensitivity Analysis Spiderplot'),
              legend: Legend(isVisible: true),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<SalesData, double>(
                    name: 'Investment',
                    dataSource: _chartData,
                    xValueMapper: (SalesData sales, _) => sales.interest,
                    yValueMapper: (SalesData sales, _) => sales.investment,
                    markerSettings: const MarkerSettings(isVisible: true),
                    enableTooltip: true),
                LineSeries<SalesData, double>(
                    name: 'Savings',
                    dataSource: _chartData,
                    xValueMapper: (SalesData sales, _) => sales.interest,
                    yValueMapper: (SalesData sales, _) => sales.savings,
                    markerSettings: const MarkerSettings(
                        isVisible: true, shape: DataMarkerType.diamond),
                    enableTooltip: true),
                LineSeries<SalesData, double>(
                    name: 'expenses',
                    dataSource: _chartData,
                    xValueMapper: (SalesData sales, _) => sales.interest,
                    yValueMapper: (SalesData sales, _) => sales.expenses,
                    markerSettings: const MarkerSettings(
                        isVisible: true, shape: DataMarkerType.pentagon),
                    enableTooltip: true),
                LineSeries<SalesData, double>(
                    name: 'life',
                    dataSource: _chartData,
                    xValueMapper: (SalesData sales, _) => sales.interest,
                    yValueMapper: (SalesData sales, _) => sales.years,
                    markerSettings: const MarkerSettings(
                        isVisible: true, shape: DataMarkerType.triangle),
                    enableTooltip: true),
              ],
              margin: const EdgeInsets.all(20),
              primaryXAxis: NumericAxis(interval: 0.1),
            )));
  }

  List<SalesData> getChartData() {
    // List<SalesData> _chartData = [];
    final List<SalesData> chartData = [
      for (int i = 0; i < widget.tables.length; i++)
        (SalesData(
            widget.tables[i]['investmentchange'],
            widget.tables[i]['interestchange'],
            widget.tables[i]['savingschange'],
            widget.tables[i]['expenseschange'],
            widget.tables[i]['yearschange'])),
    ];
    return chartData;
  }
}

class SalesData {
  SalesData(
      this.investment, this.interest, this.savings, this.expenses, this.years);
  final double interest;
  final double investment;
  final double savings;
  final double expenses;
  final double years;
}
