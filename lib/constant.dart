import 'package:flutter/material.dart';

const String loginScreen = '/login-screen ';
const String otpScreen = '/otp-screen ';
const String homeScreen = '/home-screen ';
const String groubScreen = '/groub-screen';
const String navigationScreen = '/navigation-screen';
const String initGroup = '/init_group-screen';
const String likeChat = '/like_chat';
const String addNumbers = '/add-Numbers';
const String groupImage = 'assets/j4fpsl7a.png';
void showProgressIndicator(context) {
  AlertDialog dialog = const AlertDialog(
    backgroundColor: Colors.transparent,
    content: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    ),
  );
  showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      builder: (context) {
        return dialog;
      });
}
