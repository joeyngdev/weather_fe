import 'package:flutter/material.dart';
import 'package:weather_forecast/util/overlay_handler.dart';

class Backdrop extends StatelessWidget {
  const Backdrop({super.key, required this.child, required this.isVisibility});
  final Widget child;
  final bool isVisibility;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisibility,
      child: GestureDetector(
        onTap: () {
          OverlayHandler().hide();
        },
        child: Scaffold(
            backgroundColor: const Color.fromARGB(199, 0, 0, 0), body: child),
      ),
    );
  }
}
