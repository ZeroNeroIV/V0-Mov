import 'package:hive/hive.dart';
import 'package:m0viewer/models/show_model.dart';

class FavoritesService {
  static const String _boxName = 'favorites';

  static Future<void> initialize() async {
    Hive.registerAdapter(ShowModelAdapter());
    await Hive.openBox<ShowModel>(_boxName);
  }

  static Box<ShowModel> _getFavoritesBox() {
    return Hive.box<ShowModel>(_boxName);
  }

  static Future<void> addToFavorites(ShowModel show) async {
    final box = _getFavoritesBox();
    await box.put(show.id.toString(), show);
  }

  static Future<void> removeFromFavorites(int id) async {
    final box = _getFavoritesBox();
    await box.delete(id.toString());
  }

  static bool isFavorite(int id) {
    final box = _getFavoritesBox();
    return box.containsKey(id.toString());
  }

  static List<ShowModel> getAllFavorites() {
    final box = _getFavoritesBox();
    return box.values.toList();
  }
}
