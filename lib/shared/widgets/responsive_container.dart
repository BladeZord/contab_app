import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double maxWidth;
    if (width >= 1024) {
      maxWidth = 900;
    } else if (width >= 768) {
      maxWidth = 700;
    } else {
      maxWidth = width;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
    );
  }
}