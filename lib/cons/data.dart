const field_id = 'id';
const field_symbol = 'symbol';
const field_cs1000Hour = 'cs_1000_hour';
const field_cs1000Day = 'cs_1000_day';

class ETF {
  String? id;
  String? symbol;

  List<Candlestick>? cs1000Hour;
  List<Candlestick>? cs1000Day;

  ETF.fromMap(Map<String, dynamic> map) {
    id = map[field_id];
    symbol = map[field_symbol];
    if (map[field_cs1000Hour] != null) {
      cs1000Hour = (map[field_cs1000Hour] as List)
          .map((e) => Candlestick.fromMap(e))
          .toList();
    }
    if (map[field_cs1000Day] != null) {
      cs1000Day = (map[field_cs1000Day] as List)
          .map((e) => Candlestick.fromMap(e))
          .toList();
    }
  }

  double getATR(Period period, int length) {
    List<Candlestick> csList;
    if (period == Period.hour) {
      if (cs1000Hour == null || cs1000Hour!.length < length + 1) {
        return 0.0;
      }
      csList = cs1000Hour!;
    } else {
      if (cs1000Day == null || cs1000Day!.length < length + 1) {
        return 0.0;
      }
      csList = cs1000Day!;
    }

    double atr = 0.0;
    for (int i = csList.length - length; i < csList.length; i++) {
      var cs = csList[i];
      var prevCs = csList[i - 1];
      var tr = [
        cs.high! - cs.low!,
        (prevCs.close! - cs.high!).abs(),
        (prevCs.close! - cs.low!).abs(),
      ].reduce((a, b) => a > b ? a : b);
      atr += tr;
    }
    return atr / length;
  }
}

enum Period { hour, day }

class Candlestick {
  DateTime? time;

  int? timestamp; // ms
  double? open;
  double? high;
  double? low;
  double? close;

  Candlestick();

  Candlestick.fromMap(Map<String, dynamic> map) {
    // parse from string
    open = double.tryParse(map['Open'].toString());
    high = double.tryParse(map['High'].toString());
    low = double.tryParse(map['Low'].toString());
    close = double.tryParse(map['Close'].toString());
    timestamp = map['Timestamp'];
    time = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
  }
}
