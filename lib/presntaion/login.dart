import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/constant.dart';
import 'package:news_app/logic/otp_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String phoneNum;
  var phoneVilde = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var min = 11;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneVilde.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'ادخل رقم الهاتف من فضلك',
                style: GoogleFonts.cairo(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            bulidPhoneContainer(),
            const SizedBox(
              height: 120,
            ),
            buildNextButton(context),
            buildBlocInstr(context),
          ],
        ),
      ),
    ));
  }

  Widget bulidPhoneContainer() {
    return Form(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  buildFlag() + '+20 ',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 60,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: phoneVilde,
                  autofocus: true,
                  style: GoogleFonts.cairo(
                      letterSpacing: 5,
                      fontSize: 20,
                      locale: const Locale('ar')),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'من فضلك ادخل رقم الهاتف';
                    } else if (value.length < min) {
                      return 'الرقم اقل من 11';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (formKey.currentState!.validate()) phoneNum = value;
                    debugPrint(phoneNum);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String buildFlag() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      phoneNum = phoneVilde.text;
      formKey.currentState!.save();
      BlocProvider.of<OtpCubit>(context).submitPhoneNumber(phoneNum);
    }
  }

  Widget buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          register(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 12,
        ),
        child: Text(
          'التالي',
          style: GoogleFonts.cairo(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  buildBlocInstr(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listenWhen: (previos, current) {
        return previos != current;
      },
      listener: (context, state) {
        if (state is OtpLoadingStates) {
          showProgressIndicator(context);
        }
        if (state is PhoneSubmitStates) {
          Navigator.pop(context);
          Navigator.pushNamed(context, otpScreen, arguments: phoneNum);
        }
        if (state is OtpErrorStates) {
          String error = (state).Error;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              error,
              style: const TextStyle(color: Colors.black),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.black12,
          ));
          phoneVilde.text = '';
        }
      },
      child: Container(),
    );
  }

  void showProgressIndicator(context) {
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
