import 'package:flutter/material.dart';

class ContentDivider extends StatelessWidget {
  const ContentDivider({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(title),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
