import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workaholic_pomodoro/cubit/auth_cubit/auth_cubit.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_cubit.dart';
import 'package:workaholic_pomodoro/cubit/pomodoro_cubit/pomodoro_state.dart';
import 'package:workaholic_pomodoro/screens/game/widgets/controls_widget.dart';
import 'package:workaholic_pomodoro/screens/game/widgets/daily_dialog_widget.dart';
import 'package:workaholic_pomodoro/services/local_storage.dart';
import 'package:workaholic_pomodoro/styles/colors.dart';

import 'widgets/avatar_widget.dart';
import 'widgets/status_bar_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    if (!localStorage.hasOpenToday()) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => _showDialog());
    }
    super.initState();
  }

  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      barrierColor: AppColors.darkBlue.withOpacity(0.54),
      context: context,
      builder: (BuildContext context) {
        return DailyDialogWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PomodoroCubit pomodoroCubit = context.watch<PomodoroCubit>();
    AuthCubit authCubit = context.watch<AuthCubit>();
    if (pomodoroCubit.state is PomodoroInitState) {
      if (authCubit.user != null) {
        pomodoroCubit.fetchData(authCubit.user!);
      }
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (pomodoroCubit.state is PomodoroLoadingState) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.background),
          toolbarHeight: 0,
          elevation: 0,
        ),
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              StatusBarWidget(),
              AvatarWidget(),
              ControlsWidget(),
            ],
          ),
        ),
      );
    }
  }
}
