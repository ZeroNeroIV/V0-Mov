// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:m0viewer/constants/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

enum DisplayStyle { listTile, compact, posterWithTitle }

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static const String _themeModeKey = 'theme_mode';
  static const String _displayStyleKey = 'display_style';
  static const String _primaryColorKey = 'primary_color';
  static const String _accentColorKey = 'accent_color';

  AppThemeMode _themeMode = AppThemeMode.system;
  DisplayStyle _displayStyle = DisplayStyle.posterWithTitle;
  Color _primaryColor = Colors.blue;
  Color _accentColor = Colors.amber;

  AppThemeMode get themeMode => _themeMode;
  DisplayStyle get displayStyle => _displayStyle;
  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;

  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData get lightTheme => AppThemes.lightTheme(_primaryColor, _accentColor);

  ThemeData get darkTheme => AppThemes.darkTheme(_primaryColor, _accentColor);

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> setDisplayStyle(DisplayStyle style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_displayStyleKey, style.index);
    _displayStyle = style;
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_primaryColorKey, color.value);
    _primaryColor = color;
    notifyListeners();
  }

  Future<void> setAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, color.value);
    _accentColor = color;
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex =
        prefs.getInt(_themeModeKey) ?? AppThemeMode.system.index;
    final displayStyleIndex =
        prefs.getInt(_displayStyleKey) ?? DisplayStyle.posterWithTitle.index;
    final primaryColorValue =
        prefs.getInt(_primaryColorKey) ?? Colors.blue.value;
    final accentColorValue =
        prefs.getInt(_accentColorKey) ?? Colors.amber.value;

    _themeMode = AppThemeMode.values[themeModeIndex];
    _displayStyle = DisplayStyle.values[displayStyleIndex];
    _primaryColor = Color(primaryColorValue);
    _accentColor = Color(accentColorValue);
    notifyListeners();
  }
}
