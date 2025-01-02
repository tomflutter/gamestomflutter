import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart';
import 'package:html/parser.dart' as html_parser;

const String apiKey = 'SERVER_YOU';
const String baseUrl = 'https://api.rawg.io/api/games';

class GameProvider extends ChangeNotifier {
  List<Game> _games = [];
  List<Game> _favorites = [];
  bool _isLoading = false;
  String _searchQuery = '';
  int _pageSize = 20;
  int _currentPage = 1;

  List<Game> get games => _games;
  List<Game> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  int get currentPage => _currentPage;

  GameProvider() {
    loadFavorites();
  }

  Future<void> fetchGames({int page = 1, String search = ""}) async {
    _isLoading = true;
    _searchQuery = search;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final url = Uri.parse(
        '$baseUrl?page=$page&page_size=$_pageSize&search=$search&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Full Response: ${json.encode(data)}');
      final List<dynamic> results = data['results'];
      _games = results.map((game) {
        Game newGame = Game.fromJson(game);
        print('Game description: ${newGame.description}');
        return newGame;
      }).toList();
    } else {
      throw Exception('Failed to load games');
    }

    _isLoading = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> searchGames(String query) async {
    _games.clear();
    await fetchGames(page: 1, search: query);
  }

  Future<void> resetSearch() async {
    _searchQuery = '';
    await fetchGames(page: 1, search: '');
  }

  Future<Game> fetchGameDetails(int gameId) async {
    final url = Uri.parse('$baseUrl/$gameId?key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Game game = Game.fromJson(data);

      var document = html_parser.parse(game.description);
      String cleanedDescription =
          document.body?.text ?? 'Description not available';

      game.description = cleanedDescription;

      return game;
    } else {
      throw Exception('Failed to load game details');
    }
  }

  String cleanDescription(String description) {
    var document = html_parser.parse(description);
    return document.body?.text ?? 'Description not available';
  }

  Future<void> addToFavorites(Game game) async {
    _favorites.add(game);
    saveFavorites();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> removeFromFavorites(Game game) async {
    _favorites.remove(game);
    saveFavorites();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds =
        _favorites.map((game) => game.id.toString()).toList();
    await prefs.setStringList('favorites', favoriteIds);
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favorites');

    if (favoriteIds != null && favoriteIds.isNotEmpty) {
      _favorites.clear();
      for (String id in favoriteIds) {
        await fetchGameDetails(int.parse(id)).then((game) {
          _favorites.add(game);
        });
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
