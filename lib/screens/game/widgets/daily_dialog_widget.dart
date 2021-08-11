import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/services/local_storage.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';

class DailyDialogWidget extends StatefulWidget {
  const DailyDialogWidget({Key? key}) : super(key: key);

  @override
  _DailyDialogWidgetState createState() => _DailyDialogWidgetState();
}

class _DailyDialogWidgetState extends State<DailyDialogWidget> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                'DAILY NEWS',
                style: AppTextStyles.bold8White,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              '- Game still in development, made by only one dev',
              style: AppTextStyles.regular6White,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              '- Any sugestion is welcome to jonatas.pvt@gmail.com',
              style: AppTextStyles.regular6White,
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Next features: Inventory, Shop',
              style: AppTextStyles.regular6White,
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Last updated: 25-07-2021\nAdded: Gold coin and Work coin :)',
              style: AppTextStyles.regular6White,
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    localStorage.setHasOpenToday();
                    Navigator.of(context, rootNavigator: true).pop();
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
                        'Close',
                        style: AppTextStyles.regular4White,
                      ),
                    ),
                  ),
                ),
                /*GestureDetector(
                  onTap: () {
                    _launchURL('https://www.buymeacoffee.com/jonatascm');
                  },
                  child: Container(
                    width: 30.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.kButtonLargeSuccess),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Be a supporter',
                        style: AppTextStyles.regular4White,
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
