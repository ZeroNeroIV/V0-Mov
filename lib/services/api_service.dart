// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ShowType { movie, tv }

class APIService {
  static final String _baseUrl =
      dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';
  static final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  static final String _imageBaseUrl =
      dotenv.env['TMDB_IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p/';

  static String getImageUrl(String? path, {String size = 'w500'}) {
    if (path == null) return '';
    return '$_imageBaseUrl$size$path';
  }

  static Future<List<dynamic>> getPopularShows(ShowType type,
      {int page = 1}) async {
    final endpoint = type == ShowType.movie ? 'movie/popular' : 'tv/popular';
    final response = await http
        .get(Uri.parse('$_baseUrl/$endpoint?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception(
          'Failed to load popular ${type == ShowType.movie ? 'movies' : 'series'}');
    }
  }

  static Future<Map<String, dynamic>> getShowDetails(
      int showId, ShowType type) async {
    final endpoint = type == ShowType.movie ? 'movie' : 'tv';
    final response = await http
        .get(Uri.parse('$_baseUrl/$endpoint/$showId?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load show details');
    }
  }

  static Future<List<dynamic>> getMostRecentShows(ShowType type,
      {int limit = 6, int page = 1}) async {
    final endpoint =
        type == ShowType.movie ? 'movie/now_playing' : 'tv/on_the_air';
    final response = await http
        .get(Uri.parse('$_baseUrl/$endpoint?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'] as List;
      return results.take(limit).toList();
    } else {
      throw Exception(
          'Failed to load most recent ${type == ShowType.movie ? 'movies' : 'series'}');
    }
  }

  static Future<List<dynamic>> getMostTrendingShows(ShowType type,
      {int limit = 6, int page = 1}) async {
    final endpoint = type == ShowType.movie ? 'movie' : 'tv';
    final response = await http.get(Uri.parse(
        '$_baseUrl/trending/$endpoint/week?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      final results = _checkMediaTypeAndFix(
        json.decode(response.body)['results'] as List,
        type == ShowType.movie ? 'movie' : 'tv',
      );
      return results.take(limit).toList();
    } else {
      throw Exception('Failed to load trending shows');
    }
  }

  static Future<List<dynamic>> getRecentlyReviewedShows(ShowType type,
      {int limit = 6, int page = 1}) async {
    final endpoint = type == ShowType.movie ? 'movie' : 'tv';
    final response = await http.get(
        Uri.parse('$_baseUrl/$endpoint/top_rated?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      final results = _checkMediaTypeAndFix(
        json.decode(response.body)['results'] as List,
        type == ShowType.movie ? 'movie' : 'tv',
      );
      return results.take(limit).toList();
    } else {
      throw Exception('Failed to load recently reviewed shows');
    }
  }

  static Future<bool> submitReview(
      int showId, ShowType showType, double rating, String text) async {
    final endpoint = showType == ShowType.movie ? 'movie' : 'tv';
    final url = '$_baseUrl/$endpoint/$showId/rating?api_key=$_apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'value': rating}),
    );

    if (response.statusCode == 201) {
      // The rating was successfully submitted
      print('Review submitted successfully.');
      return true;
    } else {
      // Handle the error
      throw Exception('Failed to submit review: ${response.statusCode}');
    }
  }

  static List _checkMediaTypeAndFix(List results, String type) {
    for (var element in results) {
      if (element['media_type'] == null) {
        element['media_type'] = type;
      }
    }
    return results;
  }
}
