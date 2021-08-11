import 'package:flutter/material.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_cubit.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({Key? key}) : super(key: key);

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    PomodoroCubit pomodoroCubit = context.watch<PomodoroCubit>();

    return Expanded(
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.kHammer),
                width: 40.w,
              ),
            ),
            pomodoroCubit.workCoinVideoEarn > 0 && pomodoroCubit.rewardedAd != null
                ? Positioned(
                    right: 5.w,
                    bottom: 10.h,
                    child: InkWell(
                      onTap: () {
                        pomodoroCubit.showRewardedAd();
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image(
                            fit: BoxFit.fill,
                            image: AssetImage(AppImages.kPlayAds),
                            width: 15.w,
                          ),
                          Positioned(
                            right: 0,
                            bottom: -1.5.h,
                            child: Text(
                              '+${pomodoroCubit.workCoinVideoEarn}',
                              style: AppTextStyles.bold10White,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
