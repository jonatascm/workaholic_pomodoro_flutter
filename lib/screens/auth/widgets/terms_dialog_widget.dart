import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/services/local_storage.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsDialogWidget extends StatefulWidget {
  const TermsDialogWidget({Key? key}) : super(key: key);

  @override
  _TermsDialogWidgetState createState() => _TermsDialogWidgetState();
}

class _TermsDialogWidgetState extends State<TermsDialogWidget> {
  bool isAgreed = false;

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
          children: [
            Text(
              'TERMS OF USE',
              style: AppTextStyles.bold8White,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              'This game uses thrid party advertising and analytics services.',
              style: AppTextStyles.regular6White,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              'These services require the use of an advertising identifier to show you ads, and they track in-game behavior so taht we can improve the game.',
              style: AppTextStyles.regular6White,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              'Please read  the privacy policy and the terms of use before continuing',
              style: AppTextStyles.regular6White,
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchURL('https://s3.sa-east-1.amazonaws.com/workaholic.pomodoro/terms.html');
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
                        'Terms Use',
                        style: AppTextStyles.regular4White,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL('https://s3.sa-east-1.amazonaws.com/workaholic.pomodoro/privacy.html');
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
                        'Privacy Policy',
                        style: AppTextStyles.regular4White,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAgreed = !isAgreed;
                    });
                  },
                  child: Image.asset(
                    isAgreed ? AppImages.kCheckBoxChecked : AppImages.kCheckBox,
                    width: 5.w,
                    height: 4.h,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAgreed = !isAgreed;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Container(
                      width: 27.w,
                      child: Text(
                        'I agree to all terms and policies',
                        style: AppTextStyles.regular6White,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                GestureDetector(
                  onTap: () {
                    if (isAgreed) {
                      localStorage.setFirstLaunch(overrideValue: false);
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      exit(0);
                    }
                  },
                  child: Container(
                    width: 20.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isAgreed ? AppImages.kButtonLargeSuccess : AppImages.kButtonLargeError),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isAgreed ? 'OPT-IN' : 'OPT-OUT',
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
