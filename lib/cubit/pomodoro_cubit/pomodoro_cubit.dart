import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:workaholic_pomodoro/models/game_model.dart';
import 'package:workaholic_pomodoro/models/user_model.dart';
import 'pomodoro_state.dart';

class PomodoroCubit extends Cubit<PomodoroState> {
  Timer? timer;
  final Duration loop = Duration(minutes: 25);
  Duration _countDown = Duration(minutes: 25);
  GameModel? _gameModel;
  UserModel? _userModel;
  bool hasLeveledUp = false;
  int goldCoinEarned = 0;
  int workCoinEarned = 0;
  int xpEarned = 0;
  int workCoinVideoEarn = 0;
  RewardedAd? rewardedAd;

  final _usersFirestore = FirebaseFirestore.instance.collection('users');

  PomodoroCubit() : super(PomodoroInitState());

  GameModel? get gameModel => _gameModel;

  void resetWorkCoinVideo() {
    workCoinVideoEarn = 0;
  }

  void startTimer() {
    emit(PomodoroTickState());
    _countDown = loop;
    timer?.cancel();
    playTimer();
  }

  void playTimer() {
    hasLeveledUp = false;
    timer?.cancel();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_countDown.inSeconds == 0) {
          timer.cancel();
          intervalTimer();
        } else {
          _countDown = Duration(seconds: _countDown.inSeconds - 1);
          emit(PomodoroTickState());
          emit(PomodoroPlayingState(duration: _countDown));
        }
      },
    );
  }

  void intervalTimer() {
    if (_countDown.inMinutes < 23) {
      int restTimeInSeconds = _countDown.inSeconds;
      _countDown = Duration(minutes: ((1 - _countDown.inSeconds / (25 * 60)) * 5).round());
      emit(PomodoroIntervalState(duration: _countDown));
      timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) async {
          if (_countDown.inSeconds == 0) {
            timer.cancel();
            _countDown = loop;
            await gainXpLogic(restTimeInSeconds);
            emit(PomodoroCompleteState());
          } else {
            _countDown = Duration(seconds: _countDown.inSeconds - 1);
            emit(PomodoroIntervalTickState());
            emit(PomodoroIntervalState(duration: _countDown));
          }
        },
      );
    } else {
      emit(PomodoroReadyState());
    }
  }

  void pauseTimer() {
    timer?.cancel();
    emit(PomodoroPausedState());
  }

  void resetTimer() {
    timer?.cancel();
    intervalTimer();
  }

  void readyPomodoro() {
    emit(PomodoroReadyState());
  }

  String get formatedDuration {
    final minutes = _countDown.inMinutes;
    final seconds = _countDown.inSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  Future<void> fetchData(UserModel user) async {
    try {
      emit(PomodoroLoadingState());
      _userModel = user;
      final gameSnapshot = await _usersFirestore.doc(_userModel!.uuid).get();
      final gameData = gameSnapshot.data();
      if (gameData != null) {
        _gameModel = GameModel.fromMap(gameData);
      } else {
        _gameModel = GameModel(
          xp: 0,
          level: 1,
          totalXp: 0,
          goldCoin: 0,
          workCoin: 0,
          totalCompletedPomodoro: [],
          totalTimeInSeconds: 0,
        );

        await _usersFirestore.doc(_userModel!.uuid).set({
          'xp': 0,
          'level': 1,
          'totalXp': 0,
          'goldCoin': 0,
          'workeCoin': 0,
        });
      }

      if (_gameModel != null && _userModel != null) {
        emit(PomodoroReadyState());
      }
    } catch (e) {
      emit(PomodoroErrorState(message: e.toString()));
    }
  }

  String get levelToString => _gameModel != null ? _gameModel!.level.toString() : '';
  int get levelToInt => _gameModel != null ? _gameModel!.level : 0;

  int get xpToInt => _gameModel != null ? _gameModel!.xp.toInt() : 0;

  Future<void> gainXpLogic(int restTimeInSeconds) async {
    int gameXp = _gameModel?.xp ?? 0;
    xpEarned = (pow(2, -restTimeInSeconds / 60) * 50).toInt();
    int xp = xpEarned + gameXp;

    int level = _gameModel?.level ?? 0;
    while (xpNeededToLevelUp(level: level) <= xp) {
      xp -= xpNeededToLevelUp(level: level);
      level++;
      hasLeveledUp = true;
    }

    int goldCoin = _gameModel?.goldCoin ?? 0;
    int workCoin = _gameModel?.workCoin ?? 0;
    int minumumGold = 80;
    int maximumGold = 200;
    int maximumWork = 5;

    int goldCoinEarned = 0;
    int workCoinEarned = 0;

    final _random = new Random();
    if (restTimeInSeconds < 5 * 60) {
      goldCoinEarned += minumumGold + _random.nextInt(maximumGold - minumumGold);
      goldCoin += goldCoinEarned;
      double changeGainWorkCoin = _random.nextDouble();
      if (changeGainWorkCoin < 0.3) {
        workCoinEarned = _random.nextInt(maximumWork);
        workCoin += workCoinEarned;
      }
    }

    if (workCoinVideoEarn == 0) {
      workCoinVideoEarn = 5;
    } else {
      double changeGainWorkCoin = _random.nextDouble();
      if (changeGainWorkCoin < 0.25 && workCoinVideoEarn < 50) {
        workCoinVideoEarn += _random.nextInt(maximumWork);
      }
    }

    int currentTime = (25 * 60) - restTimeInSeconds;
    int totalTime = (_gameModel?.totalTimeInSeconds ?? 0) + currentTime;

    _gameModel = _gameModel?.copyWith(
      xp: xp,
      level: level,
      totalXp: (_gameModel?.totalXp ?? 0) + xp,
      totalTimeInSeconds: totalTime,
      goldCoin: goldCoin,
      workCoin: workCoin,
    );
    await _usersFirestore.doc(_userModel!.uuid).update({'xp': xp, 'level': level, 'totalXp': _gameModel?.totalXp, 'goldCoin': goldCoin, 'workCoin': workCoin});
    loadRewardedAd();
  }

  int xpNeededToLevelUp({int? level}) => (pow(level ?? levelToInt, 1.1) + (level ?? levelToInt * 1.1) + 30).toInt();

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          rewardedAd = null;
        },
        onAdLoaded: (RewardedAd ad) {
          rewardedAd = ad;
        },
      ),
    );
  }

  void showRewardedAd() async {
    await rewardedAd?.show(
      onUserEarnedReward: (RewardedAd ad, RewardItem reward) async {
        emit(PomodoroShowingAddState());

        int workCoin = (_gameModel?.workCoin ?? 0) + workCoinVideoEarn;
        _gameModel = _gameModel?.copyWith(
          workCoin: workCoin,
        );
        workCoinVideoEarn = 0;
        await _usersFirestore.doc(_userModel!.uuid).update({'xp': _gameModel?.xp, 'level': _gameModel?.level, 'totalXp': _gameModel?.totalXp, 'goldCoin': _gameModel?.goldCoin, 'workCoin': _gameModel?.workCoin});
      },
    );
  }
}
