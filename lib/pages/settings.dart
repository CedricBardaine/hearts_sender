import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearts_sender/add_user.dart';

import 'package:hearts_sender/colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _connected = false;
  String _userId = "";

  late CollectionReference _allUsers;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((user) {
      setState(() {
        if (user == null) {
          _connected = false;
          log("PAS CONNECCCCTEEEE");
        } else {
          _connected = true;
          _userId = auth.currentUser!.uid;

          CollectionReference _allUsers =
              FirebaseFirestore.instance.collection('users');
          log("LOOOOOG : " + _allUsers.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Copy id to clipboard
                        Clipboard.setData(ClipboardData(text: _userId));

                        // And show notification
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Identifiant copié.",
                              style: TextStyle(
                                  color: Color(CustomColors.TERTIARY))),
                          duration: const Duration(seconds: 3),
                          backgroundColor: Color(CustomColors.SECONDARY),
                        ));
                      },
                      child: Text(
                        "Mon identifiant : " + _userId,
                        style: TextStyle(
                            color: _connected ? Colors.black : Colors.grey),
                      ),
                    ),
                    Container(
                      height: 16.0,
                    ),
                    Text("L'identifiant de la personne liée : " + ""),
                  ],
                ),
              ],
            ),
            TextField(),
            Expanded(child: connectionBtn()),
            AddUser("fullName", "company", 21),
          ],
        ),
      ),
    );
  }

  Widget connectionBtn() {
    if (!_connected)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Connexion "),
          IconButton(
              icon: Icon(Icons.login),
              color: Color(CustomColors.PRIMARY),
              onPressed: () {
                log("CLICK - 1 ");
                signInWithGoogle();
                log("CLICK - 2 ");
              })
        ],
      );
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Déconnexion "),
          IconButton(
              icon: Icon(Icons.logout),
              color: Colors.red,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              })
        ],
      );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
