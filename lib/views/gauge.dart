import 'package:flutter/cupertino.dart';
import 'package:myapp/cons/data.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Gauges extends StatelessWidget {
  final MarketTemperatureData mtdata;

  const Gauges(this.mtdata, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        buildGauge(mtdata.temperature!, '市场温度'),
        buildGauge(mtdata.valuation!, '市场估值'),
        buildGauge(mtdata.sentiment!, '市场情绪'),
      ],
    );
  }
}

Widget buildGauge(int value, String title) {
  return SfRadialGauge(
    enableLoadingAnimation: true,
    title: GaugeTitle(text: title),
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 100,
        pointers: <GaugePointer>[
          NeedlePointer(value: value.toDouble(), enableAnimation: true),
        ],
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 15,
            color: CupertinoColors.systemBlue,
          ),
          GaugeRange(
            startValue: 15,
            endValue: 30,
            color: CupertinoColors.systemGreen,
          ),
          GaugeRange(
            startValue: 30,
            endValue: 50,
            color: CupertinoColors.systemGrey,
          ),
          GaugeRange(
            startValue: 50,
            endValue: 70,
            color: CupertinoColors.systemYellow,
          ),
          GaugeRange(
            startValue: 70,
            endValue: 85,
            color: CupertinoColors.systemOrange,
          ),
          GaugeRange(
            startValue: 85,
            endValue: 100,
            color: CupertinoColors.systemRed,
          ),
        ],
      ),
    ],
  );
}
