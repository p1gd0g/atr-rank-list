import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/cons/pb.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/views/grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
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
            DropdownButton(
              alignment: Alignment.center,
              value: 14,
              items: [
                DropdownMenuItem(value: 14, child: Text('14')),
                DropdownMenuItem(value: 28, child: Text('28')),
              ],
              onChanged: (value) {},
            ),
            DropdownButton(
              alignment: Alignment.center,
              value: 1000,
              items: [
                DropdownMenuItem(value: 1000, child: Text('Day')),
                DropdownMenuItem(value: 60, child: Text('Hour')),
              ],
              onChanged: (value) {},
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
