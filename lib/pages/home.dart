import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hearts_sender/colors.dart';
import 'package:hearts_sender/pages/settings.dart' as settingsPage;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool _connected = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        if (user == null)
          _connected = false;
        else
          _connected = true;
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
                          print("ouille");
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
                      Text("Nombre de ❤ total : " + "###"),
                      Text("Nombre de ❤ cette semaine : " + "###"),
                      Text("Nombre de ❤ aujourd'hui : " + "###"),
                    ],
                  ),
                  Container(
                    height: 8.0,
                  ),
                  // TODO: add ❤ chart
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
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference userData =
        FirebaseFirestore.instance.collection('User').doc(userId);
    CollectionReference userHearts = userData.collection('hearts');

    userHearts.add(
        {"color": "green", "date": new DateTime.now().millisecondsSinceEpoch});
  }
}
