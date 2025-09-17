import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/cons/data.dart';
import 'package:myapp/cons/mgr.dart';
import 'package:myapp/cons/pb.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/views/grid.dart';
import 'dart:developer' as developer;

import 'package:stack_trace/stack_trace.dart';

const String appName = 'ATR Rank List';

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
        appBar: AppBar(
          title: const Text('ETF 波动率排名'),
          actions: [
            Obx(
              () => DropdownButton(
                alignment: Alignment.center,
                value: mgr.periodLength.value,
                items: [
                  DropdownMenuItem(value: 14, child: Text('14')),
                  DropdownMenuItem(value: 28, child: Text('28')),
                ],
                onChanged: (value) {
                  mgr.periodLength.value = value!;
                },
              ),
            ),
            Obx(
              () => DropdownButton(
                alignment: Alignment.center,
                value: mgr.periodUnit.value,
                items: [
                  DropdownMenuItem(value: Period.day, child: Text('Day')),
                  DropdownMenuItem(value: Period.hour, child: Text('Hour')),
                ],
                onChanged: (value) {
                  mgr.periodUnit.value = value!;
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
