import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony/constants/textStyles.dart';
import 'package:harmony/main.dart';

class DetailScreen extends StatefulWidget {
  final String videoId;

  const DetailScreen({super.key, required this.videoId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Assuming decodedJson is available here
    var items = pick(decodedJson, 'items').value as List?;
    var videoData = items?.firstWhere(
        (item) =>
            pick(item, 'id', 'videoId').asStringOrThrow() == widget.videoId,
        orElse: () => null);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title: ', style: kMusicTitleStyle.copyWith(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '${pick(videoData, 'snippet', 'title').asStringOrNull()}',
                    style: kMusicInfoStyle.copyWith(fontSize: 16)),
              ),
              Text('Description: ',
                  style: kMusicTitleStyle.copyWith(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '${pick(videoData, 'snippet', 'description').asStringOrNull()}',
                    style: kMusicInfoStyle.copyWith(fontSize: 16)),
              ),
              Text('Published At: ',
                  style: kMusicTitleStyle.copyWith(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '${pick(videoData, 'snippet', 'publishedAt').asStringOrNull()}',
                    style: kMusicInfoStyle.copyWith(fontSize: 16)),
              ),
              Text('Region Code: ',
                  style: kMusicTitleStyle.copyWith(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    '${pick(decodedJson, 'regionCode').asStringOrNull()}',
                    style: kMusicInfoStyle.copyWith(fontSize: 16)),
              ),
            ],
          )),
    );
  }
}
