// ignore: file_names
import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key, required BuildContext context})
      : super(
            content: Text("Internal Error, Server might be down"),
          );

  static void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(context: context));
  }
}