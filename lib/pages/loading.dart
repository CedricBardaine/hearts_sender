import 'package:flutter/material.dart';
import 'package:hearts_sender/loading_icon.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // alignment: Alignment.center,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Patiente un peu.", textDirection: TextDirection.ltr),
            LoadingIcon(duration: Duration(seconds: 1))
          ],
        ),
      ),
    );
  }
}
