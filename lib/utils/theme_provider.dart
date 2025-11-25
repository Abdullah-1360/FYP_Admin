import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isDarkMode = false;
  static const String _themeKey = 'is_dark_mode';

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadThemePreference() async {
    final savedTheme = await _storage.read(key: _themeKey);
    if (savedTheme != null) {
      _isDarkMode = savedTheme == 'true';
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.write(key: _themeKey, value: _isDarkMode.toString());
    notifyListeners();
  }
}