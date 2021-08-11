import 'package:flutter/material.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_cubit.dart';
import 'package:workaholic_pomodoro/styles/colors.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class StatusBarWidget extends StatefulWidget {
  const StatusBarWidget({Key? key}) : super(key: key);

  @override
  _StatusBarWidgetState createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  @override
  Widget build(BuildContext context) {
    PomodoroCubit pomodoroCubit = context.watch<PomodoroCubit>();
    double percentage = (pomodoroCubit.xpToInt / pomodoroCubit.xpNeededToLevelUp()) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 100,
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 8.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(AppImages.kLvlAvatar),
                fit: BoxFit.fill,
              )),
              child: Center(
                child: Text(
                  '${pomodoroCubit.levelToString}',
                  style: AppTextStyles.bold15Background,
                ),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Container(
              height: 100.h,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Image.asset(
                      percentage > 25
                          ? percentage > 50
                              ? percentage > 75
                                  ? AppImages.k3XpBar
                                  : AppImages.k2XpBar
                              : AppImages.k1XpBar
                          : AppImages.k0XpBar,
                      fit: BoxFit.fill,
                      width: 20.w,
                      height: 3.h,
                      semanticLabel: 'Experience bar',
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 6.5.h,
                    child: Text(
                      '${pomodoroCubit.xpToInt}/${pomodoroCubit.xpNeededToLevelUp()}',
                      style: AppTextStyles.regular6White,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${pomodoroCubit.gameModel?.goldCoin ?? 0}',
                        style: AppTextStyles.regular15White,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        AppImages.kCoin,
                        fit: BoxFit.fill,
                        width: 10.w,
                        height: 3.h,
                        semanticLabel: 'Gold Coin',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${pomodoroCubit.gameModel?.workCoin ?? 0}',
                        style: AppTextStyles.regular15White,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        AppImages.kWCoin,
                        fit: BoxFit.fill,
                        width: 10.w,
                        height: 3.h,
                        semanticLabel: 'Work Coin',
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
