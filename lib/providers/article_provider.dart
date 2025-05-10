import 'package:flutter/material.dart';
import '../models/article_form.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ArticleProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorage = LocalStorageService();

  List<ArticleForm> _articles = [];
  List<ArticleForm> _cachedFavorites = [];
  List<ArticleForm> _filteredArticles = [];
  List<int> _favoriteIds = [];
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  List<ArticleForm> get articles => _filteredArticles;
  // List<ArticleForm> get favorites => _articles.where((a) => _favoriteIds.contains(a.id)).toList();
  List<ArticleForm> get favorites {
    if (_articles.isEmpty && _error != null) {
      // Offline fallback
      return _cachedFavorites;
    }
    return _articles.where((a) => _favoriteIds.contains(a.id)).toList();
  }
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    if (_isInitialized) return;
    _favoriteIds = await _localStorage.getFavoriteIds();
    _cachedFavorites = await _localStorage.getFavoriteArticles();
    fetchArticles();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _apiService.fetchArticles();
      _filteredArticles = _articles;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchArticles(String query) {
    if (query.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles = _articles.where((article) {
        final lowerQuery = query.toLowerCase();
        return article.title.toLowerCase().contains(lowerQuery);
        // || article.body.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }

  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    final updatedFavorites = _articles
        .where((article) => _favoriteIds.contains(article.id))
        .toList();

    _localStorage.saveFavoriteIds(_favoriteIds);
    _localStorage.saveFavoriteArticles(updatedFavorites);
    notifyListeners();
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);

  Future<void> refresh() async {
    _articles = await _apiService.fetchArticles();
    _filteredArticles = _articles;
    notifyListeners();
  }

}
