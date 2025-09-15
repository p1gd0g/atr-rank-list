const field_id = 'id';
const field_symbol = 'symbol';
const field_cs1000Hour = 'cs_1000_hour';

class ETF {
  String? id;
  String? symbol;

  List<Candlestick>? cs1000Hour;
  List<Candlestick>? _csDay;

  ETF.fromMap(Map<String, dynamic> map) {
    id = map[field_id];
    symbol = map[field_symbol];
    if (map[field_cs1000Hour] != null) {
      cs1000Hour = (map[field_cs1000Hour] as List)
          .map((e) => Candlestick.fromMap(e))
          .toList();
    }
  }

  List<Candlestick> get csDay {
    if (_csDay != null) {
      return _csDay!;
    }
    if (cs1000Hour == null) {
      return [];
    }
    var dayMap = <String, Candlestick>{};
    for (var cs in cs1000Hour!) {
      var dayStr = '${cs.time!.year}-${cs.time!.month}-${cs.time!.day}';
      if (!dayMap.containsKey(dayStr)) {
        dayMap[dayStr] = Candlestick()
          ..time = DateTime(cs.time!.year, cs.time!.month, cs.time!.day)
          ..timestamp = DateTime(
            cs.time!.year,
            cs.time!.month,
            cs.time!.day,
          ).millisecondsSinceEpoch
          ..open = cs.open
          ..high = cs.high
          ..low = cs.low
          ..close = cs.close
          ..closeTimestamp = cs.timestamp;
      } else {
        var dayCs = dayMap[dayStr]!;
        dayCs.high = (dayCs.high! < cs.high!) ? cs.high : dayCs.high;
        dayCs.low = (dayCs.low! > cs.low!) ? cs.low : dayCs.low;
        if (cs.timestamp! > dayCs.closeTimestamp!) {
          dayCs.close = cs.close;
          dayCs.closeTimestamp = cs.timestamp;
        }
      }
    }
    _csDay = dayMap.values.toList()
      ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!))
      ..sublist(1); // remove the first one, which may be incomplete
    return _csDay!;
  }

  double getATR(Period period, int length) {
    List<Candlestick> csList;
    if (period == Period.hour) {
      if (cs1000Hour == null || cs1000Hour!.length < length + 1) {
        return 0.0;
      }
      csList = cs1000Hour!;
    } else {
      if (csDay.length < length + 1) {
        return 0.0;
      }
      csList = csDay;
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

  int? closeTimestamp;

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
