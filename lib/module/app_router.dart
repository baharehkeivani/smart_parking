import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking/logic/data/main_screen_cubit.dart';

import '../logic/data/login_screen_cubit.dart';
import '../ui/screen/login_screen.dart';
import '../ui/screen/main_screen.dart';
import 'constants.dart';

class AppRouter {
  AppRouter._internal();

  static final AppRouter _instance = AppRouter._internal();

  static AppRouter get instance => _instance;

  final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: "main",
      builder: (BuildContext context, GoRouterState state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider(
            create: (context) => MainScreenCubit(),
            child: const MainScreen(),
          ),
        );
      },
      redirect: (context, state) {
        if (Constants.instance.userModel == null) return "/login";
        return null;
      },
    ),
    GoRoute(
      path: '/login',
      name: "login",
      builder: (BuildContext context, GoRouterState state) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) => LoginScreenCubit(),
          child: const LoginScreen(),
        ),
      ),
    ),
  ]);

  GoRouter get router => _router;

  void clearAndNavigate(BuildContext context, String path) {
    while (context.canPop() == true) {
      context.pop();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.pushReplacement(path);
    });
  }
}
