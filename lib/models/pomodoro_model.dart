import 'dart:convert';

class PomodoroModel {
  final int workTimeInSeconds;
  final int pauseTimeInSeconds;

  PomodoroModel({
    required this.workTimeInSeconds,
    required this.pauseTimeInSeconds,
  });

  PomodoroModel copyWith({
    int? workTimeInSeconds,
    int? pauseTimeInSeconds,
  }) {
    return PomodoroModel(
      workTimeInSeconds: workTimeInSeconds ?? this.workTimeInSeconds,
      pauseTimeInSeconds: pauseTimeInSeconds ?? this.pauseTimeInSeconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'workTimeInSeconds': workTimeInSeconds,
      'pauseTimeInSeconds': pauseTimeInSeconds,
    };
  }

  factory PomodoroModel.fromMap(Map<String, dynamic> map) {
    return PomodoroModel(
      workTimeInSeconds: map['workTimeInSeconds'],
      pauseTimeInSeconds: map['pauseTimeInSeconds'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PomodoroModel.fromJson(String source) => PomodoroModel.fromMap(json.decode(source));

  @override
  String toString() => 'PomodoroModel(workTimeInSeconds: $workTimeInSeconds, pauseTimeInSeconds: $pauseTimeInSeconds)';
}
