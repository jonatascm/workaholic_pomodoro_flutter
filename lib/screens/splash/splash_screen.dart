import 'package:flutter/material.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/styles/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: AppColors.background,
      child: Center(
        child: Image(
          fit: BoxFit.contain,
          image: AssetImage(AppImages.kLogo),
          width: 90.w,
        ),
      ),
    );
  }
}
