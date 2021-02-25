import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 32.0,
        ),
        TextButton(
          onPressed: () {
            print("ouille");
          },
          child: Text("Send a heart"),
        ),
      ],
    ));
  }
}
