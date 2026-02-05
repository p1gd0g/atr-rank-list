import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:myapp/cons/data.dart';

class Mgr extends GetxController {
  var periodUnit = Period.day.obs;
  var periodLength = 14.obs;

  var refreshSignal = 0.obs;

  FPopoverController? popoverController;
}
