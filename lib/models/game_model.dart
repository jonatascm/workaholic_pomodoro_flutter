import 'dart:convert';
import './pomodoro_model.dart';

class GameModel {
  final int level;
  final int xp;
  final int totalXp;
  final int goldCoin;
  final int workCoin;
  final int totalTimeInSeconds;
  final List<PomodoroModel> totalCompletedPomodoro;

  GameModel({
    required this.level,
    required this.xp,
    required this.totalXp,
    required this.goldCoin,
    required this.workCoin,
    required this.totalTimeInSeconds,
    required this.totalCompletedPomodoro,
  });

  GameModel copyWith({
    int? level,
    int? xp,
    int? totalXp,
    int? goldCoin,
    int? workCoin,
    int? totalTimeInSeconds,
    List<PomodoroModel>? totalCompletedPomodoro,
  }) {
    return GameModel(
      level: level ?? this.level,
      xp: xp ?? this.xp,
      totalXp: totalXp ?? this.totalXp,
      goldCoin: goldCoin ?? this.goldCoin,
      workCoin: workCoin ?? this.workCoin,
      totalTimeInSeconds: totalTimeInSeconds ?? this.totalTimeInSeconds,
      totalCompletedPomodoro: totalCompletedPomodoro ?? this.totalCompletedPomodoro,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'xp': xp,
      'totalXp': totalXp,
      'goldCoin': goldCoin,
      'workCoin': workCoin,
      'totalTimeInSeconds': totalTimeInSeconds,
      'totalCompletedPomodoro': totalCompletedPomodoro,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      level: map['level'],
      xp: map['xp'],
      totalXp: map['totalXp'],
      goldCoin: map['goldCoin'] ?? 0,
      workCoin: map['workCoin'] ?? 0,
      totalTimeInSeconds: map['totalTimeInSeconds'] ?? 0,
      totalCompletedPomodoro: map['totalCompletedPomodoro'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(String source) => GameModel.fromMap(json.decode(source));

  @override
  String toString() => 'GameModel(level: $level, xp: $xp, totalXp: $totalXp, goldCoin: $goldCoin, workCoin: $workCoin, totalTimeInSeconds: $totalTimeInSeconds, totalCompletedPomodoro: $totalCompletedPomodoro)';
}
