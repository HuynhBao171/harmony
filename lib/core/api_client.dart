import 'package:dio/dio.dart';
import 'package:harmony/api_key.dart';
import 'package:harmony/model/song.dart';

class ApiClient {
  final Dio _dio = Dio();

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
        print('Failed to load search results');
        return [];
      }
    } catch (e) {
      print('Failed to load search results: $e');
      return [];
    }
  }

  Future<List<Songs>> playlistsData(String query) async {
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
        print('Failed to load search results');
        return [];
      }
    } catch (e) {
      print('Failed to load search results: $e');
      return [];
    }
  }
}
