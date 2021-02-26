import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(height: 32.0),
        TextButton(
          onPressed: () {
            print("ouille");
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.secondary;
                return Theme.of(context)
                    .colorScheme
                    .primary; // Use the component's default.
              },
            ),
          ),
          child: Text("Send a heart", style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}
