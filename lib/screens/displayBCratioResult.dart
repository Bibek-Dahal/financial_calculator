import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DisplayBCRatio extends StatefulWidget {
  final List cashFlowAfterCalc;
  final int? selectedProject;
  DisplayBCRatio(
      {Key? key,
      required this.cashFlowAfterCalc,
      required this.selectedProject})
      : super(key: key);

  @override
  State<DisplayBCRatio> createState() => _DisplayBCRatioState();
}

class _DisplayBCRatioState extends State<DisplayBCRatio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BC Ratio Result'),
      ),
      body: ListView(children: [
        SingleChildScrollView(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Project',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Cost',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Benefit',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Benefit/Cost',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                for (int i = 0; i < widget.cashFlowAfterCalc.length; i++)
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Text('${widget.cashFlowAfterCalc[i]['index'] + 1}'),
                      ),
                      DataCell(
                        Text('${widget.cashFlowAfterCalc[i]['cost']}'),
                      ),
                      DataCell(
                        Text('${widget.cashFlowAfterCalc[i]['benefit']}'),
                      ),
                      DataCell(
                        Text('${widget.cashFlowAfterCalc[i]['B/C']}'),
                      ),
                    ],
                  )
              ],
            ),
            scrollDirection: Axis.horizontal),
        Text(
            'Selected Project: ${widget.selectedProject == null ? 'Couldnt Select Project' : widget.selectedProject! + 1}')
      ]),
    );
  }
}
