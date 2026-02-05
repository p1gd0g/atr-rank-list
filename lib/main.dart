// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:myapp/firebase_options.dart';
// import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/cons/conn.dart';
import 'package:myapp/cons/data.dart';
import 'package:myapp/cons/mgr.dart';
import 'package:myapp/cons/pb.dart';
import 'package:myapp/views/bottom.dart';
import 'package:myapp/views/gauge.dart';
import 'package:myapp/views/grid.dart';
import 'package:forui/forui.dart';
import 'dart:developer' as developer;

import 'package:stack_trace/stack_trace.dart';

const String appName = 'ATRx - ETF 波动率对比';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((
  //   x,
  // ) {
  //   FirebaseAnalytics.instance.logAppOpen();
  // });

  final theme = FThemes.zinc.light;

  var pbc = Get.put(PBC());
  var mgr = Get.put(Mgr());
  var connMgr = Get.put(ConnMgr());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      logWriterCallback: (value, {isError = false}) {
        // void defaultLogWriterCallback(String value, {bool isError = false}) {
        if (isError || Get.isLogEnable) {
          developer.log(
            '[${DateTime.now()}] $value\n${Trace.current().terse.frames.getRange(1, 4).join('\n')}',
            name: 'GETX',
          );
        }
        // }
      },
      title: appName,
      theme: theme.toApproximateMaterialTheme(),

      home: FScaffold(
        footer: Bottom(),
        header: FHeader(
          title: const Text(appName),
          suffixes: [
            Obx(() {
              mgr.refreshSignal.value;

              return FPopoverMenu.tiles(
                menu: [
                  FTileGroup(
                    divider: .none,
                    children: [
                      MyTile(days: 1, period: Period.day),
                      MyTile(days: 3, period: Period.day),
                      MyTile(days: 7, period: Period.day),
                      MyTile(days: 14, period: Period.day),
                      MyTile(days: 28, period: Period.day),
                    ],
                  ),
                  FTileGroup(
                    divider: .none,
                    children: [
                      MyTile(days: 1, period: Period.hour),
                      MyTile(days: 3, period: Period.hour),
                      MyTile(days: 5, period: Period.hour),
                    ],
                  ),
                  FTileGroup(
                    divider: .none,
                    children: [
                      MyTile(days: 1, period: Period.minute),
                      MyTile(days: 2, period: Period.minute),
                      MyTile(days: 3, period: Period.minute),
                    ],
                  ),
                ],
                builder: (context, value, child) {
                  return FButton(
                    onPress: () {
                      mgr.popoverController = value;
                      mgr.popoverController?.toggle();
                    },
                    child: Text(
                      toText(mgr.periodLength.value, mgr.periodUnit.value),
                    ),
                  );
                },
              );
            }),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, parentCons) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: connMgr.fetchMarketTemperature(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: FCircularProgress());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final marketTemperature = snapshot.data!;
                        return Gauges(marketTemperature);
                      }
                    },
                  ),
                  FutureBuilder(
                    future: pbc.getETFs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: FCircularProgress());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final etfs = snapshot.data!;

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    parentCons.maxHeight - getMaxSize(context),
                              ),
                              child: DataGrid(etfs: etfs),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

class MyTile extends FTile {
  MyTile({super.key, required this.days, required this.period})
    : super(
        title: Text(toText(days, period)),
        onPress: () {
          final mgr = Get.put(Mgr());
          Get.log('PeriodTile: days=$days, period=$period');

          mgr.periodLength.value = days;
          mgr.periodUnit.value = period;

          mgr.refreshSignal.refresh();
          mgr.popoverController?.hide();
        },
      );

  final int days;
  final Period period;
}

String toText(int days, Period period) {
  if (period == Period.day) {
    return '过去 $days 个交易日';
  } else if (period == Period.hour) {
    return '过去 $days 个交易日（小时精度）';
  } else {
    return '过去 $days 个交易日（分钟精度）';
  }
}
