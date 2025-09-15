import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/cons/data.dart';
import 'package:myapp/cons/pb.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/views/grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

const collName = 'symbol';
const collPrice = 'price';
const collATR = 'atr';

class DataGrid extends StatelessWidget {
  const DataGrid({super.key, required this.etfs});

  final List<ETF> etfs;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      allowSorting: true,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: collName,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('ETF'),
          ),
        ),
        GridColumn(
          columnName: collPrice,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('价格'),
          ),
        ),
        GridColumn(
          columnName: collATR,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('ATR'),
          ),
        ),
      ],
      source: EtfDataSource(etfs),
    );
  }
}

class EtfDataSource extends DataGridSource {
  EtfDataSource(this.etfs);

  final List<ETF> etfs;

  @override
  List<DataGridRow> get rows => etfs
      .map<DataGridRow>(
        (dataRow) => DataGridRow(
          cells: [
            DataGridCell<String>(columnName: collName, value: dataRow.symbol),
            DataGridCell<String>(
              columnName: collPrice,
              value: dataRow.cs1000Hour!.last.close.toString(),
            ),
            DataGridCell(
              columnName: collATR,
              value: dataRow.getATR(Period.day, 14).toStringAsFixed(4),
            ),
          ],
        ),
      )
      .toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Text(dataCell.value.toString());
      }).toList(),
    );
  }
}
