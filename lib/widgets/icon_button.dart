import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.color = Colors.blue,
      required this.icon,
      required this.title,
      required this.onPress});
  final String title;
  final IconData icon;
  final Color color;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPress,
        label: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
