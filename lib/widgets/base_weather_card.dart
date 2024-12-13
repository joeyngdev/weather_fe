import 'package:flutter/material.dart';

class BaseWeatherCard extends StatelessWidget {
  const BaseWeatherCard(
      {super.key, required this.child, this.color = Colors.blue, this.onPress});
  final Widget child;
  final Color color;
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: color),
            child: child),
      ),
    );
  }
}
