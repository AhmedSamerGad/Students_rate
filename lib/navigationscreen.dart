import 'package:flutter/material.dart';
import 'package:news_app/logic/otp_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Navigationscreen extends StatelessWidget {
  const Navigationscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubit, OtpState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: BlocProvider.of<OtpCubit>(context)
                .screens[BlocProvider.of<OtpCubit>(context).currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
              // backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              fixedColor: Colors.blue,
              elevation: 10,
              currentIndex: BlocProvider.of<OtpCubit>(context).currentIndex,
              onTap: (index) {
                BlocProvider.of<OtpCubit>(context).changeCurrentIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Calender'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group), label: 'Groubs'),
              ]),
        );
      },
    );
  }
}
