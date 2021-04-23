import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts_sender/colors.dart';
import 'package:hearts_sender/pages/settings.dart' as settingsPage;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hearts_sender/pages/subscriber_chart.dart';

import '../subscriber_series.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool _connected = false;

  int _nbHeartsThisWeek = 0;
  int _nbHeartsThisDay = 0;

  int _lastRefresh = 0;
  int _lastNotificationShow = 0;

  List<HeartsADay> _chartData = [];

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        if (user == null)
          _connected = false;
        else
          _connected = true;
        getHearts();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _connected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          sendAHeart();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                // return Theme.of(context).colorScheme.secondary; // this way uses the defined property of ThemData of the MaterialApp()
                                return Color(CustomColors.SECONDARY);
                              return Theme.of(context)
                                  .colorScheme
                                  .primary; // Use the component's default.
                            },
                          ),
                        ),
                        child: Text("Send a heart ❤",
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                  Container(
                    height: 32.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("My hearts")],
                  ),
                  Container(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("Nombre de ❤ total : " + "###"),
                      Text("Nombre de ❤ cette semaine : " +
                          _nbHeartsThisWeek.toString()),
                      Text("Nombre de ❤ aujourd'hui : " +
                          _nbHeartsThisDay.toString()),
                    ],
                  ),
                  Container(
                    height: 8.0,
                  ),
                  SubscriberChart(
                    data: _chartData,
                  ),
                  IconButton(
                      icon: Icon(Icons.refresh),
                      color: Color(CustomColors.TERTIARY),
                      onPressed: () {
                        //
                        if (_lastRefresh <
                            new DateTime.now().millisecondsSinceEpoch - 3000)
                          setState(() {
                            getHearts();
                          });
                        //
                        else if (_lastNotificationShow <
                            new DateTime.now().millisecondsSinceEpoch - 3000) {
                          _lastNotificationShow =
                              new DateTime.now().millisecondsSinceEpoch;

                          // show notification
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Doucement.",
                                style: TextStyle(
                                    color: Color(CustomColors.TERTIARY))),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Color(CustomColors.SECONDARY),
                          ));
                        }
                        //
                      })
                ],
              )
            : Center(child: Text("Connectez vous avant tout 😁")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => settingsPage.Settings()));
        },
        tooltip: "Mes paramètres",
        child: Icon(
          Icons.settings,
          color: Color(CustomColors.TERTIARY),
        ),
      ),
    );
  }

  void sendAHeart() {
    // TODO: prevent from sending a heart if former sent was before 1h
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference userData =
        FirebaseFirestore.instance.collection('User').doc(userId);
    CollectionReference userHearts = userData.collection('hearts');

    userHearts.add(
        {"color": "green", "date": new DateTime.now().millisecondsSinceEpoch});
  }

  void getHearts() {
    _lastRefresh = new DateTime.now().millisecondsSinceEpoch;
    DateTime aWeekAgo = new DateTime.now().subtract(new Duration(days: 7));

    /// Current week day number.
    int cWDN = new DateTime.now().weekday;

    _chartData = [];

    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference userData =
        FirebaseFirestore.instance.collection('User').doc(userId);

    //
    // Fetch user's linked user.
    userData.get().then((DocumentSnapshot documentSnapshot) {
      //
      if (documentSnapshot.exists) {
        //
        String linkedUserRef = documentSnapshot.data()!['linked_to'];

        DocumentReference linkedUserData =
            FirebaseFirestore.instance.collection('User').doc(linkedUserRef);

        CollectionReference linkedUserHearts =
            linkedUserData.collection('hearts');

        //
        // Fetch linked user hearts
        linkedUserHearts
            .where('date', isGreaterThan: aWeekAgo.millisecondsSinceEpoch)
            .get()
            .then((QuerySnapshot querySnapshot) {
          /// occurencePerDay[0] = 2 : mon. 2 hearts  |  occurencePerDay[1] = 5 : tue. 5 hearts  | etc...
          List<int> occurencePerDay = new List.filled(7, 0);

          querySnapshot.docs.forEach((doc) {
            occurencePerDay[
                DateTime.fromMillisecondsSinceEpoch(doc['date']).weekday - 1]++;
          });

          // print("la liste : ");
          // print(occurencePerDay);

          setState(() {
            //
            // fill chart with database values

            _chartData.add(HeartsADay(
              day: dayNameFromIndex(validWeekDayNumber(cWDN - 6)),
              hearts: occurencePerDay[validWeekDayNumber(cWDN - 6) - 1],
              barColor: charts.ColorUtil.fromDartColor(Colors.redAccent),
            ));
            _chartData.add(HeartsADay(
              day: dayNameFromIndex(validWeekDayNumber(cWDN - 5)),
              hearts: occurencePerDay[validWeekDayNumber(cWDN - 5) - 1],
              barColor: charts.ColorUtil.fromDartColor(Colors.redAccent),
            ));
            _chartData.add(HeartsADay(
              day: dayNameFromIndex(validWeekDayNumber(cWDN - 4)),
              hearts: occurencePerDay[validWeekDayNumber(cWDN - 4) - 1],
              barColor: charts.ColorUtil.fromDartColor(Colors.redAccent),
            ));
            _chartData.add(HeartsADay(
              day: dayNameFromIndex(validWeekDayNumber(cWDN - 3)),
              hearts: occurencePerDay[validWeekDayNumber(cWDN - 3) - 1],
              barColor: charts.ColorUtil.fromDartColor(Colors.redAccent),
            ));
            _chartData.add(HeartsADay(
              day: dayNameFromIndex(validWeekDayNumber(cWDN - 2)),
              hearts: occurencePerDay[validWeekDayNumber(cWDN - 2) - 1],
              barColor: charts.ColorUtil.fromDartColor(Colors.redAccent),
            ));
            _chartData.add(HeartsADay(
              day: dayNameFromIndex(validWeekDayNumber(cWDN - 1)),
              hearts: occurencePerDay[validWeekDayNumber(cWDN - 1) - 1],
              barColor: charts.ColorUtil.fromDartColor(Colors.redAccent),
            ));
            _chartData.add(HeartsADay(
              day: dayNameFromIndex((cWDN)),
              hearts: occurencePerDay[(cWDN) - 1],
              barColor: charts.ColorUtil.fromDartColor(Colors.red),
            ));

            //
            // Add sum of hearts for the week and the day.
            _nbHeartsThisWeek = occurencePerDay[0] +
                occurencePerDay[1] +
                occurencePerDay[2] +
                occurencePerDay[3] +
                occurencePerDay[4] +
                occurencePerDay[5] +
                occurencePerDay[6];

            _nbHeartsThisDay = occurencePerDay[DateTime.now().weekday - 1];
          });
        });
      }
    });
  }

  String dayNameFromIndex(int index) {
    switch (index) {
      case 1:
        return "lun.";
      case 2:
        return "mar.";
      case 3:
        return "mer.";
      case 4:
        return "jeu.";
      case 5:
        return "ven.";
      case 6:
        return "sam.";
      case 7:
        return "dim.";
      default:
        return "ERR_" + index.toString();
    }
  }

  /// Doesn't tak in consideration index  >14  nor  <-6
  int validWeekDayNumber(int index) {
    if (index < 1)
      return index + 7;
    else if (index > 7)
      return index - 7;
    else
      return index;
  }
}
