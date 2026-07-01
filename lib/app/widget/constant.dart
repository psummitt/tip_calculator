import 'package:flutter/material.dart';

/// background `color`
const Color backgroundColor = Color(0xFFC5E4E7);
const Color primaryColor = Color(0xFF00494D);
const Color accentColor = Color(0xFF26C0AB);
const Color textColor = Color(0xFF5E7A7D);

/// default textStyle for `labels`
TextStyle labelText = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: textColor,
);

Widget logoWidget() => const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Text(
        'TIP\nCALCULATOR',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          letterSpacing: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );

BoxDecoration containerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3),
    ),
  ],
);

BoxDecoration desktopContainerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(25.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.3),
      spreadRadius: 5,
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ],
);

Widget titleDesc(String title, String desc) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          desc,
          style: const TextStyle(
            color: Color(0xFF7f9c9f),
            fontSize: 14,
          ),
        ),
      ],
    );
