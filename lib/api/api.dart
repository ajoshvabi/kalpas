import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const _apiKey = '25fc9c10d7ac4db9840e6ad26628afb8';
  static const _baseUrl = 'https://newsapi.org/v2';
  List<String> dataList = [];
  Future<Map<String, dynamic>> fetchData() async {
    const url =
        '$_baseUrl/top-headlines?country=us&category=business&apiKey=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  Future<void> storeFavs(Map<String, dynamic> article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];

    bool isAlreadyAdded = favoritesJson
        .any((fav) => jsonDecode(fav)['title'] == article['title']);

    if (!isAlreadyAdded) {
      favoritesJson.add(jsonEncode(article));
      await prefs.setStringList('favorites', favoritesJson);
    }
  }

  Future<List<Map<String, dynamic>>> getStoredFavs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    return favoritesJson
        .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
        .toList();
  }
}
