import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myapp/firebase_options.dart';
import 'dart:developer' as developer;

import 'package:stack_trace/stack_trace.dart';

const String appName = 'ATR rank list';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((
    x,
  ) {
    FirebaseAnalytics.instance.logAppOpen();
  });

  runApp(
    GetMaterialApp(
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
    ),
  );
}
