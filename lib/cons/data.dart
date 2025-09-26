const field_id = 'id';
const field_symbol = 'symbol';
const field_name = 'name';
const field_cs1000Hour = 'cs_1000_hour';
const field_cs1000Day = 'cs_1000_day';
const field_updated = 'updated';
const field_t0 = 't0';

class ETF {
  String? id;
  String? symbol;
  String? name;
  String? updated;
  bool? t0;

  List<Candlestick>? cs1000Hour;
  List<Candlestick>? cs1000Day;

  late DateTime updateTime;

  ETF.fromMap(Map<String, dynamic> map) {
    id = map[field_id];
    symbol = map[field_symbol];
    name = map[field_name];
    updated = map[field_updated];
    t0 = map[field_t0];

    updateTime = DateTime.parse(
      updated ?? DateTime.utc(1970).toIso8601String(),
    );

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

  double getTurnover(Period period, int length) {
    List<Candlestick> csList;
    if (period == Period.hour) {
      if (cs1000Hour == null || cs1000Hour!.isEmpty) {
        return 0.0;
      }
      csList = cs1000Hour!;
    } else {
      if (cs1000Day == null || cs1000Day!.isEmpty) {
        return 0.0;
      }
      csList = cs1000Day!;
    }

    double turnover = 0.0;
    for (int i = csList.length - length; i < csList.length; i++) {
      var cs = csList[i];
      turnover += (cs.turnover ?? 0.0);
    }

    return turnover;
  }
}

enum Period { minute, hour, day }

class Candlestick {
  DateTime? time;

  int? timestamp; // ms
  double? open;
  double? high;
  double? low;
  double? close;
  double? turnover; // 成交额
  double? volume; // 成交量

  Candlestick();

  Candlestick.fromMap(Map<String, dynamic> map) {
    // parse from string
    open = double.tryParse(map['Open'].toString());
    high = double.tryParse(map['High'].toString());
    low = double.tryParse(map['Low'].toString());
    close = double.tryParse(map['Close'].toString());
    turnover = double.tryParse(map['Turnover'].toString());
    volume = double.tryParse(map['Volume'].toString());
    timestamp = map['Timestamp'];
    time = DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
  }
}
