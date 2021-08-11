import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workaholic_pomodoro/screens/splash/splash_screen.dart';
import 'package:workaholic_pomodoro/styles/colors.dart';
import 'package:workaholic_pomodoro/screens/auth/widgets/version_dialog_widget.dart';
import './routes.dart';
import 'cubit/auth_cubit/auth_cubit.dart';
import 'cubit/pomodoro_cubit/pomodoro_cubit.dart';
import 'screens/auth/auth_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          routes: routes,
          navigatorObservers: <NavigatorObserver>[observer],
          title: "WorkaHolic Pomodoro",
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<PomodoroCubit>(
                  create: (BuildContext context) => PomodoroCubit(),
                ),
                BlocProvider<AuthCubit>(
                  create: (BuildContext context) => AuthCubit(),
                ),
              ],
              child: AuthScreen(),
            ),
          ),
        );
      },
    );
  }
}
