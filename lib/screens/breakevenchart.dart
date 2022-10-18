import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class BreakevenChart extends StatefulWidget {
  final List tables;
  const BreakevenChart({
    Key? key,
    required this.tables,
  }) : super(key: key);
  @override
  State<BreakevenChart> createState() => _BreakevenChartState();
}

class _BreakevenChartState extends State<BreakevenChart> {
  late List<SalesData> _chartData = [];
  late TooltipBehavior _tooltipBehavior;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    // _trackballBehavior = TrackballBehavior(
    //     enable: true,
    //     // tooltipDisplayMode: TrackballDisplayMode.floatAllPoints
    //     tooltipSettings: InteractiveTooltip(enable: true, color: Colors.red));
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Breakeven Analysis'),
            ),
            body: SfCartesianChart(
              annotations: <CartesianChartAnnotation>[
                CartesianChartAnnotation(
                  widget: Container(
                    child: Text(
                      'BEP',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 2, 186, 227),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  coordinateUnit: CoordinateUnit.point,
                  x: widget.tables[1]['bepoint']-widget.tables[1]['bepoint']/10,
                  y: widget.tables[1]['bepcost']+widget.tables[1]['bepcost']/20,
                )
              ],
              plotAreaBorderWidth: 2,
              plotAreaBorderColor: Colors.black,
              // title: ChartTitle(text: 'Sensitivity Analysis Spiderplot'),
              legend: Legend(
                  isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<SalesData, double>(
                  name: 'FixedCost',
                  dataSource: _chartData,
                  xValueMapper: (SalesData sales, _) => sales.quantity,
                  yValueMapper: (SalesData sales, _) => sales.fixedCost,
                  markerSettings: const MarkerSettings(isVisible: true),
                  enableTooltip: true,
                ),
                LineSeries<SalesData, double>(
                    name: 'Total revenue',
                    dataSource: _chartData,
                    xValueMapper: (SalesData sales, _) => sales.quantity,
                    yValueMapper: (SalesData sales, _) => sales.totalrevenue,
                    markerSettings: const MarkerSettings(
                        isVisible: true, shape: DataMarkerType.diamond),
                    enableTooltip: true),
                LineSeries<SalesData, double>(
                  name: 'Total Cost',
                  dataSource: _chartData,
                  xValueMapper: (SalesData sales, _) => sales.quantity,
                  yValueMapper: (SalesData sales, _) => sales.totalcost,
                  markerSettings: const MarkerSettings(
                      isVisible: true, shape: DataMarkerType.pentagon),
                  enableTooltip: true,
                ),
                // LineSeries<SalesData, double>(
                  
                //   dataSource: _chartData,
                //   xValueMapper: (SalesData sales, _) => sales.bepoint,
                //   yValueMapper: (SalesData sales, _) => sales.bepcost,
                //   // markerSettings: const MarkerSettings(
                //   //     isVisible: true, shape: DataMarkerType.horizontalLine),
                //   enableTooltip: true,
                // ),
              ],

              // primaryXAxis: NumericAxis(interval: 0.1),
            )));
  }

  List<SalesData> getChartData() {
    List<SalesData> _chartData = [];
    final List<SalesData> chartData = [
      // SalesData(10000,450000,450000,200000),
      // SalesData(20000,450000,550000,400000),
      // SalesData(30000,450000,650000,600000),
      // SalesData(40000,450000,750000,800000),
      // SalesData(50000,450000,850000,1000000),
      // SalesData(60000,450000,950000,1200000),
      // SalesData(70000,450000,1050000,1400000),

      for (int i = 0; i < widget.tables.length; i++)
        (SalesData(
          widget.tables[i]['quantity'],
          widget.tables[i]['fixedcost'],
          widget.tables[i]['totalcost'],
          widget.tables[i]['totalrevenue'],
          widget.tables[i]['bepcost'],
          widget.tables[i]['bepoint'],
        )),
    ];
    return chartData;
  }
}

class SalesData {
  SalesData(this.quantity, this.fixedCost, this.totalcost, this.totalrevenue,
      this.bepcost, this.bepoint);
  final double quantity;
  final double fixedCost;
  final double totalcost;
  final double totalrevenue;
  final double bepcost;
  final double bepoint;
}
