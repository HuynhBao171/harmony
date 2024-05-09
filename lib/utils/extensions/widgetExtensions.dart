import 'package:flutter/widgets.dart';

extension PaddingExtension on Widget {
  Widget padding(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );
}
