import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DarkModeState extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    Hive.box('isdarkmode').put('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> initializeDarkMode() async {
    _isDarkMode = Hive.box('isdarkmode').get('isDarkMode', defaultValue: false);
    notifyListeners();
  }
}
