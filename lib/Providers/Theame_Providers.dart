import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}