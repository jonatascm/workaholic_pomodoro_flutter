import 'package:equatable/equatable.dart';

class PomodoroState extends Equatable {
  final Duration? duration;

  PomodoroState({this.duration});
  @override
  List<Object?> get props => [];
}

class PomodoroInitState extends PomodoroState {}

class PomodoroReadyState extends PomodoroState {}

class PomodoroCompleteState extends PomodoroState {}

class PomodoroLoadingState extends PomodoroState {}

class PomodoroPlayingState extends PomodoroState {
  final Duration duration;

  PomodoroPlayingState({required this.duration});
}

class PomodoroPausedState extends PomodoroState {}

class PomodoroIntervalState extends PomodoroState {
  final Duration duration;

  PomodoroIntervalState({required this.duration});
}

class PomodoroErrorState extends PomodoroState {
  final String message;

  PomodoroErrorState({required this.message});
}

class PomodoroLevelUpState extends PomodoroState {
  final int level;

  PomodoroLevelUpState({required this.level});
}

class PomodoroTickState extends PomodoroState {}

class PomodoroIntervalTickState extends PomodoroState {}

class PomodoroShowingAddState extends PomodoroState {}
