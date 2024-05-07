import 'package:deep_pick/deep_pick.dart';
import 'package:flutter/material.dart';
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
          children: <Widget>[
            Text(
                'Title: ${pick(videoData, 'snippet', 'title').asStringOrNull()}'),
            Text(
                'Description: ${pick(videoData, 'snippet', 'description').asStringOrNull()}'),
            Text(
                'Published At: ${pick(videoData, 'snippet', 'publishedAt').asStringOrNull()}'),
            Text(
                'Region Code: ${pick(decodedJson, 'regionCode').asStringOrNull()}'),
            // Image.network(pick(decodedJson, 'thumbnails', 'default', 'url')
            //     .asStringOrThrow()),
          ],
        ),
      ),
    );
  }
}
