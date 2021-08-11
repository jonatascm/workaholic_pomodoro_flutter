import 'package:flutter/material.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';
import 'package:sizer/sizer.dart';

enum LoginType { google, facebook, guest }

class LoginButtonWidget extends StatefulWidget {
  final void Function() onTap;
  final LoginType type;
  const LoginButtonWidget({Key? key, required this.onTap, required this.type}) : super(key: key);

  @override
  _LoginButtonWidgetState createState() => _LoginButtonWidgetState();
}

class _LoginButtonWidgetState extends State<LoginButtonWidget> {
  @override
  Widget build(BuildContext context) {
    String loginText = '';
    String icon = '';
    switch (widget.type) {
      case LoginType.google:
        icon = AppImages.kGoogleLogo;
        loginText = 'Google';
        break;
      case LoginType.facebook:
        icon = AppImages.kFacebookLogo;
        loginText = 'Facebook';
        break;
      case LoginType.guest:
        icon = AppImages.kGuest;
        loginText = 'Guest';
        break;
    }

    return InkWell(
      onTap: widget.onTap,
      child: Stack(children: [
        Center(
          child: Image.asset(
            AppImages.kButtonLarge,
            fit: BoxFit.fill,
            width: 70.w,
            height: 8.5.h,
            semanticLabel: 'Login with $loginText',
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(right: 45.w, top: 1.h),
            child: Image.asset(
              icon,
              fit: BoxFit.fill,
              width: 13.w,
              height: 6.h,
            ),
          ),
        ),
        Center(
          child: Container(
            width: 65.w,
            height: 8.5.h,
            child: Padding(
              padding: EdgeInsets.only(top: 3.h, left: 18.w),
              child: Text(
                '${loginText.toUpperCase()}',
                style: AppTextStyles.regular15White,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
