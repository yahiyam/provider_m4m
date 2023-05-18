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

class ViewModeState extends ChangeNotifier {
  bool _isGridMode = false;
  bool get isGridMode => _isGridMode;
  toggleViewMode() {
    _isGridMode = !_isGridMode;
    notifyListeners();
  }

  Icon viewIcon() {
    notifyListeners();
    return Icon(
      _isGridMode ? Icons.list : Icons.grid_view,
    );
  }

  Text viewLabel() {
    notifyListeners();
    return _isGridMode
        ? const Text(
            'List View',
          )
        : const Text(
            'Grid View',
          );
  }
}
