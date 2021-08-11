import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_cubit.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';

class CompletePomodoroDialogWidget extends StatefulWidget {
  final PomodoroCubit pomodoroCubit;
  const CompletePomodoroDialogWidget({Key? key, required this.pomodoroCubit}) : super(key: key);

  @override
  _CompletePomodoroDialogWidgetState createState() => _CompletePomodoroDialogWidgetState();
}

class _CompletePomodoroDialogWidgetState extends State<CompletePomodoroDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 13.w),
        width: 90.w,
        height: 45.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.kDialogBox),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.w,
              child: Text(
                'CONGRATULATIONS!\n\nYOU HAVE FINISHED A POMODORO CICLE',
                style: AppTextStyles.bold8White,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'You earned',
              style: AppTextStyles.regular8White,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              'Xp: ${widget.pomodoroCubit.xpEarned}',
              style: AppTextStyles.regular8White,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              'Gold Coin: ${widget.pomodoroCubit.goldCoinEarned}',
              style: AppTextStyles.regular8White,
            ),
            SizedBox(
              height: 1.h,
            ),
            widget.pomodoroCubit.workCoinEarned > 0
                ? Text(
                    'Work Coin: ${widget.pomodoroCubit.workCoinEarned}',
                    style: AppTextStyles.regular8White,
                  )
                : SizedBox(),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.pomodoroCubit.readyPomodoro();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Container(
                    width: 27.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.kButtonLarge),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: AppTextStyles.regular6White,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
