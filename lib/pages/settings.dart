import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hearts_sender/colors.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _connected = false;
  String _userId = "";

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
                      child: Text("Mon identifiant : " + _userId),
                    ),
                    Container(
                      height: 16.0,
                    ),
                    Text("L'identifiant de la personne liée : " + ""),
                  ],
                ),
              ],
            ),
            Expanded(child: connectionBtn())
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
                signInWithGoogle();
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
