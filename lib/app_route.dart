import 'package:flutter/material.dart';
import 'package:news_app/logic/calendar_cubit.dart';
import 'package:news_app/logic/otp_cubit.dart';
import 'package:news_app/model/groubs.dart';
import 'package:news_app/navigationscreen.dart';
import 'package:news_app/presntaion/chats.dart';
import 'package:news_app/presntaion/contacts.dart';
import 'package:news_app/presntaion/groups/groubscreen.dart';
import 'package:news_app/presntaion/groups/initlizegroup.dart';
import 'package:news_app/presntaion/homeScreen.dart';
import 'package:news_app/presntaion/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/presntaion/otpScreen.dart';

import 'constant.dart';

class AppRouter {
  OtpCubit? otpCubit;
  CalendarCubit? calendarCubit;


  AppRouter() {
    otpCubit = OtpCubit();
    calendarCubit = CalendarCubit();
  }

  Route? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case loginScreen:
        return _createRoute(BlocProvider<OtpCubit>.value(
          value: otpCubit!,
          child: const Login(),
        ));
      case otpScreen:
        return _createRoute(BlocProvider<OtpCubit>.value(
          value: otpCubit!,
          child: Otpscreen(
            phoneNumber: setting.arguments.toString(),
          ),
        ));
      case homeScreen:
        return _createRoute(const CalendarScreen());
      case navigationScreen:
        return _createRoute(const Navigationscreen());
      case groubScreen:
        return _createRoute(const Groubscreen());
      case initGroup:
        return _createRoute(const InitlizeGroup());
      case likeChat:
        return _createRoute(ChatScreen(
          group: setting.arguments as Groups,
        ));
      case addNumbers:
        return _createRoute(const Conacts());
    }
    return null;
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => page,
    );
  }
}
