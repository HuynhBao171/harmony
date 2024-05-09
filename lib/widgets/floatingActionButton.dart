// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';


class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    required this.padding,
    required this.backgroundColor,
    required this.iconData,
    required this.onPressed,
    required this.heroTag
  });

  final EdgeInsets padding;
  final IconData iconData;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String heroTag;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 65,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: heroTag,
            backgroundColor: backgroundColor,
            onPressed: onPressed,
            child: Icon(iconData, size: 35,),
          ),
        ),
      ),
    );
  }
}