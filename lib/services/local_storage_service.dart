import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_form.dart';

class LocalStorageService {
  static const _favoriteIdsKey = 'favorite_article_ids';
  static const _favoriteArticlesKey = 'favorite_articles';

  Future<void> saveFavoriteIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteIdsKey, ids.map((e) => e.toString()).toList());
  }

  Future<List<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteIdsKey)?.map(int.parse).toList() ?? [];
  }

  Future<void> saveFavoriteArticles(List<ArticleForm> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((a) => a.toJson()).toList();
    await prefs.setString(_favoriteArticlesKey, jsonEncode(jsonList));
  }

  Future<List<ArticleForm>> getFavoriteArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoriteArticlesKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((a) => ArticleForm.fromJson(a)).toList();
  }
}
