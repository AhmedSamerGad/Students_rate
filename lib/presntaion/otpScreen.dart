import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/constant.dart';
import 'package:news_app/logic/otp_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Otpscreen extends StatefulWidget {
  Otpscreen({super.key, required this.phoneNumber});
  final String phoneNumber;
  String getPhone() {
    return phoneNumber;
  }

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  String otp = '';

  var pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ستصلك رسالة برقم التاكيد ',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                    text: 'سيتم ارسال رسالة التأكيد علي الرقم ',
                    style: GoogleFonts.cairo(
                        fontSize: 20, color: Colors.black87, height: 2),
                    children: [
                      TextSpan(
                          text: widget.phoneNumber,
                          style: GoogleFonts.sansita(
                              color: Colors.blue, fontSize: 20)),
                    ]),
              ),
              const SizedBox(
                height: 110,
              ),
              builtPinCode(context),
              const SizedBox(
                height: 110,
              ),
              builtVerifyButton(context),
              buildBlocListener(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildBlocListener() {
    return BlocListener<OtpCubit, OtpState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is OtpVerified) {
            Navigator.pop(context);
            Navigator.pushNamed(context, navigationScreen);
          }
        },
        child: Container());
  }

  Widget builtPinCode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: PinCodeTextField(
        controller: pinController,
        length: 6,
        enableActiveFill: true,
        keyboardType: TextInputType.phone,
        autoFocus: true,
        pinTheme: PinTheme(
          activeColor: Colors.grey,
          activeFillColor: Colors.grey,
          inactiveColor: Colors.white,
          inactiveFillColor: Colors.grey,
          selectedColor: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        obscureText: false,
        animationType: AnimationType.fade,
        animationDuration: Duration(milliseconds: 300),
        onCompleted: (value) {
          debugPrint(value);
          otp = value;
        },
        // Pass it here
        appContext: context,
      ),
    );
  }

  Widget builtVerifyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            showProgressIndicator(context);
            BlocProvider.of<OtpCubit>(context).otpSubmitted(otp);
            BlocProvider.of<OtpCubit>(context)
                .savePhoneNumbers(widget.phoneNumber);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            elevation: 12,
          ),
          child: Text(
            'تأكيد',
            style: GoogleFonts.cairo(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog dialog = const AlertDialog(
      // backgroundColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.black),
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
}
