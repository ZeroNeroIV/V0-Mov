import 'package:m0viewer/models/show.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WatchlistService {
  static const String _watchlistKey = 'watchlist';

  static Future<List<Show>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final watchlistJson = prefs.getString(_watchlistKey);
    if (watchlistJson == null) {
      return [];
    }
    final watchlistData = json.decode(watchlistJson) as List;
    return watchlistData.map((item) => Show.fromJson(item)).toList();
  }

  static Future<void> addToWatchlist(Show show) async {
    final watchlist = await getWatchlist();
    if (!watchlist.any((item) => item.id == show.id)) {
      watchlist.add(show);
      await _saveWatchlist(watchlist);
    }
  }

  static Future<void> removeFromWatchlist(int showId) async {
    final watchlist = await getWatchlist();
    watchlist.removeWhere((item) => item.id == showId);
    await _saveWatchlist(watchlist);
  }

  static Future<bool> isInWatchlist(int showId) async {
    final watchlist = await getWatchlist();
    return watchlist.any((item) => item.id == showId);
  }

  static Future<void> _saveWatchlist(List<Show> watchlist) async {
    final prefs = await SharedPreferences.getInstance();
    final watchlistJson =
        json.encode(watchlist.map((item) => item.toJson()).toList());
    await prefs.setString(_watchlistKey, watchlistJson);
  }
}
