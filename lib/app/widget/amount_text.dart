import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {
  final String text;
  final String label;

  const AmountText({
    Key? key,
    required this.text,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: \$$text',
      child: Text(
        '\$${text.toUpperCase()}',
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Color(0xFF26C0AB),
        ),
      ),
    );
  }
}
