import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_cubit.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';

class CompleteAdsDialogWidget extends StatefulWidget {
  final PomodoroCubit pomodoroCubit;
  const CompleteAdsDialogWidget({Key? key, required this.pomodoroCubit}) : super(key: key);

  @override
  _CompleteAdsDialogWidgetState createState() => _CompleteAdsDialogWidgetState();
}

class _CompleteAdsDialogWidgetState extends State<CompleteAdsDialogWidget> {
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
          children: [
            SizedBox(
              height: 6.h,
            ),
            Container(
              child: Text(
                'YOU EARNED',
                style: AppTextStyles.bold10White,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              '${widget.pomodoroCubit.workCoinVideoEarn} WORK COINS',
              style: AppTextStyles.bold10White,
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.pomodoroCubit.resetWorkCoinVideo();
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
