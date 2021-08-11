import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workaholic_pomodoro/constants/images.dart';
import 'package:workaholic_pomodoro/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workaholic_pomodoro/screens/login/login_button_widget.dart';
import 'package:workaholic_pomodoro/styles/colors.dart';
import 'package:workaholic_pomodoro/styles/text_styles.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.watch<AuthCubit>();
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.background),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
            color: AppColors.background,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  fit: BoxFit.contain,
                  image: AssetImage(AppImages.kLogo),
                  width: 90.w,
                ),
                SizedBox(
                  height: 5.h,
                ),
                LoginButtonWidget(
                  onTap: () async {
                    await authCubit.fetchGoogleSignIn();
                  },
                  type: LoginType.google,
                ),
                SizedBox(
                  height: 2.h,
                ),
                LoginButtonWidget(
                  onTap: () async {
                    await authCubit.fetchFacebookLogin();
                  },
                  type: LoginType.facebook,
                ),
                SizedBox(
                  height: 2.h,
                ),
                LoginButtonWidget(
                  onTap: () async {
                    await authCubit.fetchGuestLogin();
                  },
                  type: LoginType.guest,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'CONTINUE',
                  style: AppTextStyles.regular15White,
                ),
              ],
            )),
      ),
    );
  }
}
