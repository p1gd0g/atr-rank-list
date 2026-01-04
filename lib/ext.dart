import 'package:flutter/widgets.dart';

extension ColorExtensions on Color {
  Color myWithOpacity(double alpha) {
    // map alpha to 0.1 and 0.9
    alpha = (alpha * 0.8 + 0.1).clamp(0.1, 0.9);

    return withAlpha((alpha * 255).toInt());
  }
}

extension DateTimeExtensions on DateTime {
  String toShortDateString() {
    return '$year-$month-$day';
  }
}