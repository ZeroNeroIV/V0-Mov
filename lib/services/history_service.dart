import 'package:hive_flutter/hive_flutter.dart';
import 'package:m0viewer/models/history_model.dart';

class HistoryService {
  static const String _boxName = 'history';

  static Future<void> initialize() async {
    Hive.registerAdapter(HistoryModelAdapter());
    await Hive.openBox<String>(_boxName);
  }

  static Box<String> _getHistoryBox() {
    return Hive.box<String>(_boxName);
  }

  static Future<void> addToHistory(String showId) async {
    final box = _getHistoryBox();
    await box.put(showId, showId);
  }

  static Future<void> removeFromHistory(String showId) async {
    final box = _getHistoryBox();
    await box.delete(showId);
  }

  static bool isHistory(String showId) {
    final box = _getHistoryBox();
    return box.containsKey(showId);
  }

  static List<String> getAllHistory() {
    final box = _getHistoryBox();
    return box.values.toList();
  }
}
