import 'package:dio/dio.dart';
import 'package:harmony/api_key.dart';
import 'package:harmony/model/song.dart';

class YoutubeApi {
  final Dio _dio = Dio();
  String? errorMessage;

  Future<List<Songs>> searchYoutube(String query) async {
    try {
      var response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'maxResults': '25',
          'q': query,
          'type': 'video',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        var items = List<Map<String, dynamic>>.from(response.data['items']);
        return items.map((item) => Songs.fromJson(item)).toList();
      } else {
        errorMessage = 'Failed to load search results: status code ${response.statusCode}';
        return [];
      }
    } catch (e) {
      errorMessage = 'Failed to load search results: $e';
      return [];
    }
  }
}