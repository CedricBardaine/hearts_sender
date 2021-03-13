import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Oh Oh... Quelque chose de pas normal s'est tramé ici.",
            textDirection: TextDirection.ltr),
      ),
    );
  }
}
