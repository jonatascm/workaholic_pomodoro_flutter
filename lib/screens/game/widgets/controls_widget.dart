import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_cubit.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_state.dart';
import 'package:workaholic_pomodoro/styles/colors.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';

import 'complete_ads_dialog_widget.dart';
import 'complete_pomodoro_dialog_widget.dart';

class ControlsWidget extends StatefulWidget {
  const ControlsWidget({Key? key}) : super(key: key);

  @override
  _ControlsWidgetState createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  bool _leftButtonPressed = false;
  bool _rightButtonPressed = false;

  final BannerAd banner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  )..load();

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  @override
  Widget build(BuildContext context) {
    PomodoroCubit pomodoroCubit = context.watch<PomodoroCubit>();
    double width = MediaQuery.of(context).size.width;

    if (pomodoroCubit.state is PomodoroCompleteState) {
      Future.delayed(Duration(seconds: 1), () {
        showDialog(
          barrierDismissible: false,
          barrierColor: AppColors.darkBlue.withOpacity(0.54),
          context: context,
          builder: (BuildContext context) {
            return CompletePomodoroDialogWidget(pomodoroCubit: pomodoroCubit);
          },
        );
      });
    }

    if (pomodoroCubit.state is PomodoroShowingAddState) {
      Future.delayed(Duration(seconds: 1), () {
        showDialog(
          barrierDismissible: false,
          barrierColor: AppColors.darkBlue.withOpacity(0.54),
          context: context,
          builder: (BuildContext context) {
            return CompleteAdsDialogWidget(pomodoroCubit: pomodoroCubit);
          },
        );
      });
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              pomodoroCubit.formatedDuration,
              textAlign: TextAlign.center,
              style: AppTextStyles.bold20White,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                pomodoroCubit.state is PomodoroPlayingState || pomodoroCubit.state is PomodoroPausedState || pomodoroCubit.state is PomodoroTickState
                    ? Align(
                        child: AnimatedPadding(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.only(left: pomodoroCubit.state is PomodoroReadyState ? 0 : width * 0.5),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTapCancel: () {
                              setState(() {
                                _rightButtonPressed = false;
                              });
                            },
                            onTapDown: (_) {
                              setState(() {
                                _rightButtonPressed = true;
                              });
                            },
                            onTap: () {
                              pomodoroCubit.resetTimer();
                              setState(() {
                                _rightButtonPressed = false;
                              });
                            },
                            child: Container(
                              child: Image.asset(
                                _rightButtonPressed ? AppImages.kButtonStopPressed : AppImages.kButtonStop,
                                fit: BoxFit.fill,
                                width: 20.w,
                                height: 8.5.h,
                                semanticLabel: 'Stop pomodoro',
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                pomodoroCubit.state is PomodoroPlayingState || pomodoroCubit.state is PomodoroTickState || pomodoroCubit.state is PomodoroReadyState || pomodoroCubit.state is PomodoroPausedState
                    ? Align(
                        child: AnimatedPadding(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.only(right: pomodoroCubit.state is PomodoroReadyState ? 0 : width * 0.5),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTapCancel: () {
                              setState(() {
                                _leftButtonPressed = false;
                              });
                            },
                            onTapDown: (_) {
                              setState(() {
                                _leftButtonPressed = true;
                              });
                            },
                            onTap: () {
                              if (pomodoroCubit.state is PomodoroReadyState) {
                                pomodoroCubit.startTimer();
                              } else if (pomodoroCubit.state is PomodoroPlayingState) {
                                pomodoroCubit.pauseTimer();
                              } else if (pomodoroCubit.state is PomodoroPausedState) {
                                pomodoroCubit.playTimer();
                              }

                              setState(() {
                                _leftButtonPressed = false;
                              });
                            },
                            child: Container(
                              child: pomodoroCubit.state is PomodoroReadyState || pomodoroCubit.state is PomodoroPausedState
                                  ? Image.asset(
                                      _leftButtonPressed ? AppImages.kButtonPlayPressed : AppImages.kButtonPlay,
                                      fit: BoxFit.fill,
                                      width: 20.w,
                                      height: 8.5.h,
                                      semanticLabel: 'Play pomodoro',
                                    )
                                  : pomodoroCubit.state is PomodoroPlayingState || pomodoroCubit.state is PomodoroTickState
                                      ? Image.asset(
                                          _leftButtonPressed ? AppImages.kButtonPausePressed : AppImages.kButtonPause,
                                          fit: BoxFit.fill,
                                          width: 20.w,
                                          height: 8.5.h,
                                          semanticLabel: 'Pause pomodoro',
                                        )
                                      : SizedBox(),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 8.5.h,
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            child: AdWidget(ad: banner),
            width: banner.size.width.toDouble(),
            height: banner.size.height.toDouble(),
          ),
        ],
      ),
    );
  }
}
