import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:myapp/cons/data.dart';
import 'package:myapp/cons/mgr.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

const collName = 'symbol';
const collPrice = 'price';
const collATR = 'atr';
const collATRPercent = 'atr%';

class DataGrid extends StatelessWidget {
  const DataGrid({super.key, required this.etfs});

  final List<ETF> etfs;

  @override
  Widget build(BuildContext context) {
    var mgr = Get.put(Mgr());
    return Obx(() {
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
          GridColumn(
            columnName: collATRPercent,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: const Text('ATR%'),
            ),
          ),
        ],
        source: EtfDataSource(
          etfs,
          mgr.periodUnit.value,
          mgr.periodLength.value,
        ),
      );
    });
  }
}

class EtfDataSource extends DataGridSource {
  EtfDataSource(this.etfs, this.periodUnit, this.periodLength);

  final List<ETF> etfs;
  final Period periodUnit;
  final int periodLength;

  @override
  List<DataGridRow> get rows => etfs.map<DataGridRow>((dataRow) {
    // var mgr = Get.put(Mgr());
    var basePrice = periodUnit == Period.day
        ? (dataRow.cs1000Day?.last.close ?? 0.0)
        : (dataRow.cs1000Hour?.last.close ?? 0.0);

    var atr = dataRow.getATR(periodUnit, periodLength);
    var atrPercent = (basePrice == 0.0) ? 0.0 : atr / basePrice * 100;

    return DataGridRow(
      cells: [
        DataGridCell<String>(columnName: collName, value: dataRow.symbol),
        DataGridCell<String>(
          columnName: collPrice,
          value: basePrice.toString(),
        ),
        DataGridCell(columnName: collATR, value: atr.toStringAsFixed(4)),
        DataGridCell(
          columnName: collATRPercent,
          value: '${atrPercent.toStringAsFixed(2)}%',
        ),
      ],
    );
  }).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Text(dataCell.value.toString());
      }).toList(),
    );
  }
}
