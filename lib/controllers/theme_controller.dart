import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  bool isDarkTheme = Get.isDarkMode;

  final GetStorage _storage = GetStorage();
  final String _key = "isDarkTheme";

  // Getting the theme from the phone storage
  ThemeMode get theme =>
      _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;

  // Is the app in dark theme or not? False->Light Theme; True-> Dark Theme
  // When the app runs for the first time, by default it will be set in light theme
  bool _loadThemeFromStorage() => _storage.read(_key) ?? false;

  _saveThemeToStorage(bool isDarkMode) => _storage.write(_key, isDarkMode);

  void toggleTheme() {
    Get.changeThemeMode(
        _loadThemeFromStorage() ? ThemeMode.light : ThemeMode.dark);

    _saveThemeToStorage(!_loadThemeFromStorage());

    isDarkTheme = !isDarkTheme;

    update();
  }
}
