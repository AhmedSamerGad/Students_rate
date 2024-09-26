import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/model/phones.dart';
import 'package:news_app/model/users.dart';

import '../presntaion/groups/groubscreen.dart';
import '../presntaion/homeScreen.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  late String verificationId;
  Future<void> submitPhoneNumber(String phone) async {
    emit(OtpLoadingStates());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+20$phone',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    debugPrint('verificationCompleted');
    await Signin(credential);
  }

  void verificationFailed(FirebaseAuthException e) {
    debugPrint('verificationFailed ${e.toString()}');

    emit(OtpErrorStates(e.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    debugPrint('codeSend');
    emit(PhoneSubmitStates());
  }

  Future<void> otpSubmitted(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otp);
    await Signin(credential);
  }

  Future<void> savePhoneNumbers(String phoneNumber) async {
    PhoneProperties phoneProperties =
        PhoneProperties(groups: [], userType: UserType.student);
    return await FirebaseFirestore.instance
        .collection('PhoneNumbers')
        .doc(phoneNumber)
        .set(phoneProperties.toMap());
  }

  Future<void> Signin(PhoneAuthCredential credential) async {
    FirebaseAuth.instance.signInWithCredential(credential).then((onValue) {
      debugPrint('Login success');
      emit(OtpVerified());
    }).catchError((onError) {
      debugPrint(onError.toString());
      emit(OtpErrorStates(onError.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const CalendarScreen(),
    const Groubscreen(),
  ];
  void changeCurrentIndex(int index) {
    currentIndex = index;

    emit(ChangeNavIndex(index));
    print(state);
  }

  List<String> titles = ['Calendar ', 'Groups'];
}
