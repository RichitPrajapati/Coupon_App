import 'package:flutter/material.dart';


snackBar(
    {required BuildContext context,
      required String message,
      required Color color,
      required IconData icon}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            message,
          ),
        ],
      ),
    ),
  );
}
