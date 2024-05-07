// ignore_for_file: file_names

class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video(
      {required this.id,
      required this.title,
      required this.thumbnailUrl,
      required this.channelTitle});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      channelTitle: json['snippet']['channelTitle'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id/videoId': id,
        'snippet/title': title,
        'snippet/thumbnails/high/url': thumbnailUrl,
        'snippet/channelTitle': channelTitle,
      };
}

// class Songs {
//   final String id;
//   final String title;
//   final String thumbnailUrl;
//   final String channelTitle;

//   Songs(
//       {required this.id,
//       required this.channelTitle,
//       required this.title,
//       required this.thumbnailUrl});

  // factory Songs.fromJson(Map<String, dynamic> json) {
  //   return Songs(
  //     id: json['id']['videoId'],
  //     title: json['snippet']['title'],
  //     thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
  //     channelTitle: json['snippet']['channelTitle'],
  //   );
  // }
  // Map<String, dynamic> toJson() => {
  //       'id/videoId': id,
  //       'snippet/title': title,
  //       'snippet/thumbnails/high/url': thumbnailUrl,
  //       'snippet/channelTitle': channelTitle,
  //     };
// }

class AlbumCards {
  final String id;
  final String title;
  final String? subtitle;
  final String iconUrl;

  AlbumCards(
      {required this.id,
      required this.title,
      required this.iconUrl,
      this.subtitle});
}

var dailyMix = [
  AlbumCards(
      id: "1",
      title: "Daily Mix 1",
      iconUrl: 'assets/images/album_cover/dailyMix1.png'),
  AlbumCards(
      id: "2",
      title: "Daily Mix 2",
      iconUrl: 'assets/images/album_cover/dailyMix2.jpeg'),
  AlbumCards(
      id: "3",
      title: "Daily Mix 3",
      iconUrl: 'assets/images/album_cover/dailyMix3.jpeg'),
  AlbumCards(
      id: "4",
      title: "Daily Mix 4",
      iconUrl: 'assets/images/album_cover/dailyMix4.jpeg'),
  AlbumCards(
      id: "5",
      title: "Daily Mix 5",
      iconUrl: 'assets/images/album_cover/dailyMix5.jpeg'),
];

var albums = [
  AlbumCards(
      id: "1",
      title: "Desi Hip-Hop",
      iconUrl: 'assets/images/album_cover/album1.jpeg'),
  AlbumCards(
      id: "2",
      title: "English Hip-Hop",
      iconUrl: 'assets/images/album_cover/album2.jpeg'),
  AlbumCards(
      id: "3",
      title: "English Songs",
      iconUrl: 'assets/images/album_cover/album3.png'),
  AlbumCards(
      id: "4",
      title: "Classical Hindi Songs",
      iconUrl: 'assets/images/album_cover/album4.jpeg'),
];
