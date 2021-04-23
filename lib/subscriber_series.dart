import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class HeartsADay {
  final String day;
  final int hearts;
  final charts.Color barColor;

  HeartsADay({required this.day, required this.hearts, required this.barColor});
}
