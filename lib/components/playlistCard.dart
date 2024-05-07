// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../constants/textStyles.dart';


class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.imageUrl,
    required this.text,

  });
  final String imageUrl;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0,8,16,8),
          child: SizedBox(
            height: 150,
            width: 150,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset(imageUrl),
            ),

          ),
        ),
        Text(
          "  $text",
          style: kMusicInfoStyle,
        ),
      ],
    );
  }
}
