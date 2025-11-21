import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/cons/data.dart';
import 'package:myapp/cons/mgr.dart';
import 'package:myapp/ext.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

const collName = 'symbol';
const collPrice = 'price';
const collHigh = 'high';
const collLow = 'low';
const collTurnover = 'turnover';
const collChange = 'change';
const collATR = 'atr';
const collATRPercent = 'atr%';
const collUpdateTime = 'updateTime';
const collTPlus = 't0';
const collOHLCLength = 'ohlcLength';
const collOHLCLengthPercent = 'ohlcLength%';

class DataGrid extends StatelessWidget {
  const DataGrid({super.key, required this.etfs});

  final List<ETF> etfs;

  @override
  Widget build(BuildContext context) {
    var mgr = Get.put(Mgr());
    return Obx(() {
      return SfDataGrid(
        allowSorting: true,
        frozenColumnsCount: 1,
        allowMultiColumnSorting: true,
        headerGridLinesVisibility: GridLinesVisibility.both,
        gridLinesVisibility: GridLinesVisibility.both,
        // columnWidthMode: context.width > 800
        //     ? ColumnWidthMode.fill
        //     : ColumnWidthMode.auto,

        isScrollbarAlwaysShown: true,
        // showVerticalScrollbar: true,
        // showHorizontalScrollbar: true,
        columns: [
          GridColumn(
            width: 150,
            columnName: collName,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('ETF'),
            ),
          ),

          GridColumn(
            columnName: collTPlus,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('交收'),
            ),
          ),

          GridColumn(
            columnName: collPrice,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('价格'),
            ),
          ),

          GridColumn(
            columnName: collHigh,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('最高'),
            ),
          ),

          GridColumn(
            columnName: collLow,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('最低'),
            ),
          ),

          GridColumn(
            columnName: collChange,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('涨跌幅'),
            ),
          ),
          GridColumn(
            columnName: collTurnover,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('成交额'),
            ),
          ),
          GridColumn(
            columnName: collATR,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('ATR'),
            ),
          ),
          GridColumn(
            columnName: collATRPercent,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'ATR%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: collOHLCLength,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('OHLC步长'),
            ),
          ),
          GridColumn(
            columnName: collOHLCLengthPercent,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'OHLC步长%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridColumn(
            columnName: collUpdateTime,
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('更新时间'),
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
    var atrPercent = dataRow.getATRPercent(periodUnit, periodLength);

    var ohlcLength = dataRow.getOHLCLength(periodUnit, periodLength);
    var ohlcLengthPercent = dataRow.getOHLCLengthPercent(
      periodUnit,
      periodLength,
    );

    var turnover = dataRow.getTurnover(periodUnit, periodLength);

    // var name = '${dataRow.name}\n${dataRow.symbol?.split('.').first}';

    return DataGridRow(
      cells: [
        DataGridCell(
          columnName: collName,
          value: (dataRow.name, dataRow.symbol),
        ),
        DataGridCell<String>(
          columnName: collTPlus,
          value: (dataRow.t0 == true) ? 't+0' : 't+1',
        ),
        DataGridCell<String>(
          columnName: collPrice,
          value: basePrice.toString(),
        ),

        DataGridCell<String>(
          columnName: collHigh,
          value: dataRow.getHigh(periodUnit, periodLength).toString(),
        ),
        DataGridCell<String>(
          columnName: collLow,

          value: dataRow.getLow(periodUnit, periodLength).toString(),
        ),

        DataGridCell<double>(
          columnName: collChange,
          value: dataRow.getChange(periodUnit, periodLength),
        ),
        DataGridCell<double>(columnName: collTurnover, value: turnover),

        DataGridCell(columnName: collATR, value: atr.toStringAsFixed(4)),
        DataGridCell(columnName: collATRPercent, value: atrPercent),

        DataGridCell(
          columnName: collOHLCLength,
          value: ohlcLength.toStringAsFixed(3),
        ),
        DataGridCell(
          columnName: collOHLCLengthPercent,
          value: ohlcLengthPercent,
        ),

        DataGridCell(
          columnName: collUpdateTime,
          value: dataRow.updateTime.toLocal().toString().split(' ').first,
        ),
      ],
    );
  }).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        if (dataCell.columnName == collName) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (dataCell.value as (String, String)).$2.split('.').first,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                (dataCell.value as (String, String)).$1,
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        var str = switch (dataCell.columnName) {
          collATRPercent => '${(dataCell.value as double).toStringAsFixed(2)}%',
          collOHLCLengthPercent =>
            '${(dataCell.value as double).toStringAsFixed(2)}%',
          collTurnover =>
            '${((dataCell.value as double) / 1e8).toStringAsFixed(2)}亿',
          collChange => '${(dataCell.value as double).toStringAsFixed(2)}%',

          _ => dataCell.value.toString(),
        };

        var fontWeight = switch (dataCell.columnName) {
          collName => FontWeight.bold,
          _ => FontWeight.normal,
        };

        var color = getColor(dataCell.columnName, row);
        return Container(
          color: color,
          alignment: Alignment.center,
          child: Text(
            str,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: fontWeight),
          ),
        );
      }).toList(),
    );
  }

  Color getColor(String columnName, DataGridRow row) {
    var color = Colors.white;
    // clone etfs
    var etfs = List<ETF>.from(this.etfs);
    if (columnName == collATRPercent) {
      etfs.sort((a, b) {
        var aAtrPercent = a.getATRPercent(periodUnit, periodLength);
        var bAtrPercent = b.getATRPercent(periodUnit, periodLength);
        return aAtrPercent.compareTo(bAtrPercent);
      });
      var index = etfs.indexWhere(
        (etf) =>
            etf.symbol == (row.getCells().first.value as (String, String)).$2,
      );
      var percent = index / etfs.length;
      color = Colors.red.myWithOpacity(percent);
    } else if (columnName == collOHLCLengthPercent) {
      etfs.sort((a, b) {
        var aOhlcLengthPercent = a.getOHLCLengthPercent(
          periodUnit,
          periodLength,
        );
        var bOhlcLengthPercent = b.getOHLCLengthPercent(
          periodUnit,
          periodLength,
        );
        return aOhlcLengthPercent.compareTo(bOhlcLengthPercent);
      });
      var index = etfs.indexWhere(
        (etf) =>
            etf.symbol == (row.getCells().first.value as (String, String)).$2,
      );
      var percent = index / etfs.length;
      color = Colors.red.myWithOpacity(percent);
    } else if (columnName == collTurnover) {
      // var etfs = List<ETF>.from(this.etfs);
      etfs.sort((a, b) {
        var aTurnover = a.getTurnover(periodUnit, periodLength);
        var bTurnover = b.getTurnover(periodUnit, periodLength);
        return aTurnover.compareTo(bTurnover);
      });
      var index = etfs.indexWhere(
        (etf) =>
            etf.symbol == (row.getCells().first.value as (String, String)).$2,
      );
      var percent = index / etfs.length;
      color = Colors.red.myWithOpacity(percent);
    } else if (columnName == collChange) {
      etfs.sort((a, b) {
        var aChange = a.getChange(periodUnit, periodLength);
        var bChange = b.getChange(periodUnit, periodLength);
        return aChange.compareTo(bChange);
      });

      var index = etfs.indexWhere(
        (etf) =>
            etf.symbol == (row.getCells().first.value as (String, String)).$2,
      );

      if (etfs[index].getChange(periodUnit, periodLength) == 0) {
      } else if (etfs[index].getChange(periodUnit, periodLength) > 0) {
        etfs = etfs
            .where((etf) => etf.getChange(periodUnit, periodLength) > 0)
            .toList();
        var redCount = etfs.length;
        var index = etfs.indexWhere(
          (etf) =>
              etf.symbol == (row.getCells().first.value as (String, String)).$2,
        );
        // 如果只有一个，应该为最不红的，percent 应该为 0
        var percent = index / redCount;
        color = Colors.red.myWithOpacity(percent);
      } else {
        etfs = etfs
            .where((etf) => etf.getChange(periodUnit, periodLength) < 0)
            .toList();

        var greenCount = etfs.length;
        var index = etfs.indexWhere(
          (etf) =>
              etf.symbol == (row.getCells().first.value as (String, String)).$2,
        );
        // 如果只有一个，应该为最不绿的，percent 应该为 0
        var percent = (greenCount - (index + 1)) / greenCount;
        color = Colors.green.myWithOpacity(percent);
      }
    } else if (columnName == collTPlus) {
      row.getCells()[1].value == 't+0'
          ? color = Colors.red.myWithOpacity(0.5)
          : null;
    }

    return color;
  }
}
