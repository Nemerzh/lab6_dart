import 'package:flutter/material.dart';

class ResultField extends StatelessWidget {
  const ResultField({
    super.key,
    required this.value,
    this.width = 100,
    this.backgroundColor,
  });

  final String value;
  final double width;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ??
        Theme.of(context).colorScheme.secondaryContainer;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        color: color,
        child: SizedBox(
          width: width,
          height: 70,
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
