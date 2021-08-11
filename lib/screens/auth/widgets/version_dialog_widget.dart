import 'dart:io';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:sizer/sizer.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';

class VersionDialogWidget extends StatefulWidget {
  const VersionDialogWidget({Key? key}) : super(key: key);

  @override
  _VersionDialogWidgetState createState() => _VersionDialogWidgetState();
}

class _VersionDialogWidgetState extends State<VersionDialogWidget> {
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
            Text(
              'NEW VERSION RELEASED',
              style: AppTextStyles.bold8White,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Please update to newer version!',
              style: AppTextStyles.regular10White,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    LaunchReview.launch(writeReview: false, androidAppId: "com.jcmdevs.workaholic_pomodoro");
                  },
                  child: Container(
                    width: 20.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.kButtonLarge),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'UPDATE',
                        style: AppTextStyles.regular4White,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    exit(0);
                  },
                  child: Container(
                    width: 25.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.kButtonLarge),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'LEAVE',
                        style: AppTextStyles.regular4White,
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
