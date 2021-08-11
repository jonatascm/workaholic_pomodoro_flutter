import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workaholic_pomodoro/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workaholic_pomodoro/cubit/auth_cubit/auth_state.dart';
import 'package:workaholic_pomodoro/screens/auth/widgets/terms_dialog_widget.dart';
import 'package:workaholic_pomodoro/screens/auth/widgets/version_dialog_widget.dart';
import 'package:workaholic_pomodoro/screens/game/game_screen.dart';
import 'package:workaholic_pomodoro/screens/login/login_screen.dart';
import 'package:workaholic_pomodoro/screens/splash/splash_screen.dart';
import 'package:workaholic_pomodoro/services/local_storage.dart';
import 'package:workaholic_pomodoro/styles/colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future checkDialog() async {
    bool update = await needUpdate();
    if (update) {
      _showDialogVersion();
    } else if (localStorage.isFirstLanch()) {
      _showDialogTerms();
    } else {
      return null;
    }
  }

  Future<bool> needUpdate() async {
    final RemoteConfig? remoteConfig = RemoteConfig.instance;
    if (remoteConfig != null) {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(minutes: 30),
      ));
      await remoteConfig.fetchAndActivate();
      dynamic minimumVersionAllowed = remoteConfig.getString('minimum_version');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      dynamic appVersion = packageInfo.version;

      if (appVersion != null && minimumVersionAllowed != '') {
        dynamic appVersionParts = appVersion.split('.');
        dynamic minimumVersionAllowedParts = minimumVersionAllowed.split('.');
        if (minimumVersionAllowedParts.length == appVersionParts.length) {
          for (int i = 0; i < minimumVersionAllowedParts.length; i++) {
            if (int.parse(minimumVersionAllowedParts[i]) > int.parse(appVersionParts[i])) {
              return true;
            } else if (int.parse(minimumVersionAllowedParts[i]) < int.parse(appVersionParts[i])) {
              break;
            }
          }
        }
      }
    }
    return false;
  }

  void _showDialogTerms() {
    showDialog(
      barrierDismissible: false,
      barrierColor: AppColors.darkBlue.withOpacity(0.54),
      context: context,
      builder: (BuildContext context) {
        return TermsDialogWidget();
      },
    );
  }

  void _showDialogVersion() {
    showDialog(
      barrierDismissible: false,
      barrierColor: AppColors.darkBlue.withOpacity(0.54),
      context: context,
      builder: (BuildContext context) {
        return VersionDialogWidget();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => checkDialog());
  }

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.watch<AuthCubit>();

    return FutureBuilder(
        future: needUpdate(),
        builder: (_, snapshot) {
          if (snapshot.data == true) {
            return SplashScreen();
          }
          if (authCubit.state is AuthInitState) {
            authCubit.fetchAutoLogin();
            return SplashScreen();
          } else if (authCubit.state is AuthAuthenticatedState) {
            return GameScreen();
          } else if (authCubit.state is AuthNotAuthenticatedState) {
            return LoginScreen();
          } else {
            return SplashScreen();
          }
        });
  }
}
