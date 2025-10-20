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
              () => DropdownButton(
                alignment: Alignment.center,
                value: mgr.periodLength.value,
                items: [
                  // DropdownMenuItem(value: 1, child: Text('1')),
                  DropdownMenuItem(value: 7, child: Text('7')),
                  DropdownMenuItem(value: 14, child: Text('14')),
                  DropdownMenuItem(value: 28, child: Text('28')),
                  // DropdownMenuItem(value: 42, child: Text('42')),
                  DropdownMenuItem(value: 56, child: Text('56')),
                  DropdownMenuItem(value: 112, child: Text('112')),

                  DropdownMenuItem(
                    value: 999,
                    enabled: false,
                    child: Text('999', style: TextStyle(color: Colors.grey)),
                  ),
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
                  DropdownMenuItem(
                    value: Period.minute,
                    enabled: false,
                    child: Text('Minute', style: TextStyle(color: Colors.grey)),
                  ),
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
