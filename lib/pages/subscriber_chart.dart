import 'package:flutter/material.dart';

import '../subscriber_series.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class SubscriberChart extends StatelessWidget {
  final List<HeartsADay> data;

  SubscriberChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<HeartsADay, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (HeartsADay series, _) => series.day,
          measureFn: (HeartsADay series, _) => series.hearts,
          colorFn: (HeartsADay series, _) => series.barColor)
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "❤️ chart of the week",
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
