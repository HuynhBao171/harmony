import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harmony/api_key.dart';
import 'package:harmony/main.dart';
import 'package:harmony/model/song.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> searchYoutube(String query) async {
    try {
      var response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          'part': 'snippet',
          'maxResults': '15',
          'q': query,
          'type': 'video',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Failed to load search results');
        return {};
      }
    } catch (e) {
      print('Failed to load search results: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> searchYoutubeNextPage(
      String query, String nextPageToken) async {
    try {
      var response = await _dio.get(
        'https://www.googleapis.com/youtube/v3/search',
        queryParameters: {
          'nextPageToken': nextPageToken,
          'part': 'snippet',
          'maxResults': '15',
          'q': query,
          'type': 'video',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Failed to load search results');
        return {};
      }
    } catch (e) {
      print('Failed to load search results: $e');
      return {};
    }
  }

  Future<void> getDetailsUser() async {
    User? user = getIt<FirebaseAuth>().currentUser;
    logger.i("User: $user");
    if (user != null) {
      logger.i("User: ${user.displayName}");
      String username = user.displayName ?? "";
      String photoUrl = user.photoURL ?? "";
      String email = user.email ?? "Error Fetching Email";

      Map<String, String> userData = {
        'username': username,
        'photoUrl': photoUrl,
        'email': email,
      };

      FlutterSecureStorage storage = getIt<FlutterSecureStorage>();
      // await storage.delete(key: 'currentUser');
      await storage.write(key: 'currentUser', value: jsonEncode(userData));
    }
  }
}
