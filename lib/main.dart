import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hearts_sender/colors.dart';
import 'package:hearts_sender/pages/error.dart';
import 'package:hearts_sender/pages/home.dart';
import 'package:hearts_sender/pages/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Error();

          if (snapshot.connectionState == ConnectionState.done)
            return MaterialApp(
              title: 'Hearts Sender',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.

                // 0xFF669C5E
                primarySwatch:
                    const MaterialColor(0xFF669C5E, const <int, Color>{
                  50: const Color(0xFF669C5E),
                  100: const Color(0xFF669C5E),
                  200: const Color(0xFF669C5E),
                  300: const Color(0xFF669C5E),
                  400: const Color(0xFF669C5E),
                  500: const Color(0xFF669C5E),
                  600: const Color(0xFF669C5E),
                  700: const Color(0xFF669C5E),
                  800: const Color(0xFF669C5E),
                  900: const Color(0xFF669C5E),
                }),
                primaryColor: Color(CustomColors.PRIMARY),
                accentColor: Color(CustomColors.SECONDARY),

                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: Loading(),
            );

          return Loading();
        });
  }
}
