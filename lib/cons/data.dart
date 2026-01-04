import 'package:get/get.dart';
import 'package:myapp/ext.dart';

const field_id = 'id';
const field_symbol = 'symbol';
const field_name = 'name';
const field_cs1000Hour = 'cs_1000_hour';
const field_cs1000Day = 'cs_1000_day';
const field_cs1000Minute = 'cs_1000_minute';
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
  List<Candlestick>? cs1000Minute;

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
    if (map[field_cs1000Minute] != null) {
      cs1000Minute = (map[field_cs1000Minute] as List)
          .map((e) => Candlestick.fromMap(e))
          .toList();
    }
  }

  // double getChange(Period period, int length) {
  //   var csList = getList(period);
  //   if (csList.isEmpty) {
  //     return 0.0;
  //   }

  //   var startPrice = csList[csList.length - length - 1].close ?? 0.0;
  //   var endPrice = csList.last.close ?? 0.0;
  //   if (startPrice == 0.0) {
  //     return 0.0;
  //   }
  //   return (endPrice - startPrice) / startPrice * 100;
  // }

  double getChangeV2(Period period, int days) {
    var csList = getListV2(period, days);
    if (csList.$1.isEmpty) {
      return 0.0;
    }

    var startPrice = csList.$2?.close ?? 0.0;
    var endPrice = csList.$1.last.close ?? 0.0;
    if (startPrice == 0.0) {
      return 0.0;
    }
    return (endPrice - startPrice) / startPrice * 100;
  }

  // List<Candlestick> getList(Period period) {
  //   if (period == Period.hour) {
  //     return cs1000Hour ?? [];
  //   } else if (period == Period.day) {
  //     return cs1000Day ?? [];
  //   } else if (period == Period.minute) {
  //     return cs1000Minute ?? [];
  //   } else {
  //     return [];
  //   }
  // }

  Map<String, (List<Candlestick>, Candlestick?)> cache = {};

  (List<Candlestick>, Candlestick?) getListV2(Period period, int days) {
    String key = '${period.name}_$days';
    if (cache.containsKey(key)) {
      return cache[key]!;
    }

    var result = _getListV2(period, days);
    cache[key] = result;
    return result;
  }

  (List<Candlestick>, Candlestick?) _getListV2(Period period, int days) {
    final list = switch (period) {
      Period.hour => cs1000Hour,
      Period.day => cs1000Day,
      Period.minute => cs1000Minute,
    };

    if (list == null || list.isEmpty) {
      return ([], null);
    }

    var daySet = <String>{};

    var listResult = <Candlestick>[];
    Candlestick? prevCs;

    for (var i = 0; i < list.length; i++) {
      final cs = list.reversed.elementAt(i);

      if (daySet.contains(cs.time!.toShortDateString())) {
        listResult.add(cs);
      } else {
        daySet.add(cs.time!.toShortDateString());

        if (daySet.length > days) {
          prevCs = cs;
          break;
        }

        listResult.add(cs);
      }
    }

    // Get.log(
    //   'getListV2: period=$period, day=$days, listResult.length=${listResult.length}',
    // );

    return (listResult.reversed.toList(), prevCs);
  }

  // double getHigh(Period period, int length) {
  //   List<Candlestick> csList = getList(period);

  //   double high = csList[csList.length - length].high ?? 0.0;
  //   for (int i = csList.length - length; i < csList.length; i++) {
  //     var cs = csList[i];
  //     if ((cs.high ?? 0.0) > high) {
  //       high = cs.high ?? 0.0;
  //     }
  //   }
  //   return high;
  // }

  double getHighV2(Period period, int days) {
    List<Candlestick> csList = getListV2(period, days).$1;
    return csList.map((e) => e.high ?? 0.0).reduce((a, b) => a > b ? a : b);
  }

  // double getLow(Period period, int length) {
  //   List<Candlestick> csList = getList(period);

  //   double low = csList[csList.length - length].low ?? double.infinity;
  //   for (int i = csList.length - length; i < csList.length; i++) {
  //     var cs = csList[i];
  //     if ((cs.low ?? double.infinity) < low) {
  //       low = cs.low ?? double.infinity;
  //     }
  //   }
  //   return low == double.infinity ? 0.0 : low;
  // }

  double getLowV2(Period period, int days) {
    List<Candlestick> csList = getListV2(period, days).$1;
    return csList.map((e) => e.low ?? 0).reduce((a, b) => a < b ? a : b);
  }

  // double getATR(Period period, int length) {
  //   List<Candlestick> csList = getList(period);

  //   double atr = 0.0;
  //   for (int i = csList.length - length; i < csList.length; i++) {
  //     var cs = csList[i];
  //     var prevCs = csList[i - 1];
  //     var tr = [
  //       cs.high! - cs.low!,
  //       (prevCs.close! - cs.high!).abs(),
  //       (prevCs.close! - cs.low!).abs(),
  //     ].reduce((a, b) => a > b ? a : b);
  //     atr += tr;
  //   }
  //   return atr / length;
  // }

  double getATRV2(Period period, int days) {
    List<Candlestick> csList = getListV2(period, days).$1;
    if (csList.isEmpty) {
      return 0.0;
    }
    var prevCs = getListV2(period, days).$2!;

    double atr = 0.0;
    for (int i = 0; i < csList.length; i++) {
      var cs = csList[i];
      var tr = [
        cs.high! - cs.low!,
        (prevCs.close! - cs.high!).abs(),
        (prevCs.close! - cs.low!).abs(),
      ].reduce((a, b) => a > b ? a : b);
      atr += tr;
      prevCs = cs;
    }
    return atr / days;
  }

  // double getATRPercent(Period period, int length) {
  //   List<Candlestick> csList = getList(period);

  //   double atr = getATR(period, length);
  //   double basePrice = csList.last.close ?? 0.0;
  //   if (basePrice == 0.0) {
  //     return 0.0;
  //   }
  //   return atr / basePrice * 100;
  // }

  double getATRPercentV2(Period period, int days) {
    List<Candlestick> csList = getListV2(period, days).$1;

    double atr = getATRV2(period, days);
    double basePrice = csList.last.close ?? 0.0;
    if (basePrice == 0.0) {
      return 0.0;
    }
    return atr / basePrice * 100;
  }

  double getTurnover(Period period, int days) {
    List<Candlestick> csList = getListV2(period, days).$1;
    double turnover = 0.0;
    for (var cs in csList) {
      turnover += cs.turnover ?? 0.0;
    }
    return turnover;
  }

  double getOHLCLength(Period period, int days) {
    var csList = getListV2(period, days).$1;
    var pcs = getListV2(period, days).$2!;

    double ohlcLength = 0.0;

    for (int i = 0; i < csList.length; i++) {
      var cs = csList[i];

      // c - o
      ohlcLength += ((pcs.close ?? 0.0) - (cs.open ?? 0.0)).abs();
      // o - h
      ohlcLength += ((cs.open ?? 0.0) - (cs.high ?? 0.0)).abs();
      // h - l
      ohlcLength += ((cs.high ?? 0.0) - (cs.low ?? 0.0)).abs();
      // l - c
      ohlcLength += ((cs.low ?? 0.0) - (cs.close ?? 0.0)).abs();

      pcs = cs;
    }

    return ohlcLength;
  }

  double getOHLCLengthPercent(Period period, int days) {
    var csList = getListV2(period, days).$1;

    double ohlcLength = getOHLCLength(period, days);
    double basePrice = csList.last.close ?? 0.0;
    if (basePrice == 0.0) {
      return 0.0;
    }
    return ohlcLength / basePrice * 100;
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

class MarketTemperatureData {
  int? temperature;
  String? description;
  int? valuation;
  int? sentiment;
  String? updatedAt;

  MarketTemperatureData({
    this.temperature,
    this.description,
    this.valuation,
    this.sentiment,
    this.updatedAt,
  });

  MarketTemperatureData.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    description = json['description'];
    valuation = json['valuation'];
    sentiment = json['sentiment'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temperature'] = temperature;
    data['description'] = description;
    data['valuation'] = valuation;
    data['sentiment'] = sentiment;
    data['updated_at'] = updatedAt;
    return data;
  }
}
