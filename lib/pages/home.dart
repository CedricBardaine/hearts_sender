import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        ),
      ),
    );
  }
}
