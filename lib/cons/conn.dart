import 'package:get/get.dart';
import 'package:myapp/cons/data.dart';

class ConnMgr extends GetConnect {
  // https://api.p1gd0g.cc/MarketTemperature?market=CN&target=lp

  Future<MarketTemperatureData?> fetchMarketTemperature({
    String market = 'CN',
    String target = 'lp',
  }) async {
    var rsp = await get<MarketTemperatureData?>(
      'https://api.p1gd0g.cc/MarketTemperature',
      query: {'market': market, 'target': target},
      decoder: (data) {
        if (data == null) return null;
        return MarketTemperatureData.fromJson(data);
      },
    );

    return rsp.body;
  }
}
