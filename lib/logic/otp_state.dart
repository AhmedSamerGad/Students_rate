part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoadingStates extends OtpState {}

class PhoneSubmitStates extends OtpState {}

class OtpErrorStates extends OtpState {
  final Error;

  OtpErrorStates(this.Error);
}

class OtpVerified extends OtpState {}

class ChangeNavIndex extends OtpState {
  final int index;

  ChangeNavIndex(this.index);
}
