import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_stats.dart';

class StatsProvider with ChangeNotifier {
  PlayerStats _stats = PlayerStats();
  PlayerStats get stats => _stats;

  StatsProvider() {
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString('player_stats');
    if (statsJson != null) {
      _stats = PlayerStats.fromJson(json.decode(statsJson));
      notifyListeners();
    }
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_stats', json.encode(_stats.toJson()));
  }

  void updateStats({bool isWin = false, bool isDraw = false}) {
    _stats.updateStats(isWin: isWin, isDraw: isDraw);
    _saveStats();
    notifyListeners();
  }
}
