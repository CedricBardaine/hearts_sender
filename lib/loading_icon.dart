import 'package:flutter/material.dart';

class LoadingIcon extends StatefulWidget {
  LoadingIcon({Key? key, required this.duration}) : super(key: key);

  final Duration duration;

  @override
  _LoadingIconState createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoadingIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = Duration(seconds: 1);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      icon: AnimatedIcons.menu_arrow,
      progress: _controller,
    );
  }
}
