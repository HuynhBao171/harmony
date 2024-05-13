import 'dart:convert';

class Songs {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Songs(
      {required this.id,
      required this.channelTitle,
      required this.title,
      required this.thumbnailUrl});

  factory Songs.fromJson(Map<String, dynamic> json) {
    return Songs(
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': {'videoId': id},
        'snippet': {
          'title': title,
          'thumbnails': {
            'high': {'url': thumbnailUrl}
          },
          'channelTitle': channelTitle,
        },
      };

  static Songs fromJsonString(String jsonString) {
    return Songs.fromJson(json.decode(jsonString));
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}
