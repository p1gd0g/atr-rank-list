import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/cons/data.dart';
import 'package:myapp/cons/mgr.dart';
import 'package:myapp/cons/pb.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/views/bottom.dart';
import 'package:myapp/views/grid.dart';
import 'dart:developer' as developer;

import 'package:stack_trace/stack_trace.dart';

const String appName = 'ATRX - ETF 波动率排名';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((
    x,
  ) {
    FirebaseAnalytics.instance.logAppOpen();
  });

  var pbc = Get.put(PBC());
  var mgr = Get.put(Mgr());

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
      theme: FlexThemeData.light(scheme: FlexScheme.purpleBrown),

      home: Scaffold(
        bottomNavigationBar: Bottom(),
        // bottomSheet: Bottom(),
        appBar: AppBar(
          title: const Text(
            appName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          actions: [
            Obx(
              () => DropdownButton<(int, Period)>(
                alignment: Alignment.center,
                value: (mgr.periodLength.value, mgr.periodUnit.value),
                items: [
                  /// 按天计算
                  DropdownMenuItem(
                    value: (14, Period.day),
                    child: Text('过去 14 交易日'),
                  ),
                  DropdownMenuItem(
                    value: (30, Period.day),
                    child: Text('过去 30 交易日'),
                  ),
                  DropdownMenuItem(
                    value: (60, Period.day),
                    child: Text('过去 60 交易日'),
                  ),

                  DropdownMenuItem(enabled: false, child: const Divider()),

                  /// 按小时计算
                  DropdownMenuItem(
                    value: (4, Period.hour),
                    child: Text('过去 4 交易小时'),
                  ),
                  DropdownMenuItem(
                    value: (12, Period.hour),
                    child: Text('过去 12 交易小时'),
                  ),
                  DropdownMenuItem(
                    value: (24, Period.hour),
                    child: Text('过去 24 交易小时'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    mgr.periodLength.value = value.$1;
                    mgr.periodUnit.value = value.$2;
                  }
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: pbc.getETFs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final etfs = snapshot.data!;
              return DataGrid(etfs: etfs);
            }
          },
        ),
      ),
    ),
  );
}
