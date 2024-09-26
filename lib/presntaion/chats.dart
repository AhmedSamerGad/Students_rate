import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/logic/users_cubit.dart';
import 'package:news_app/model/groubs.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.group});
  final Groups group;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersCubit(),
      child: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                group.name,
              ),
            ),
          );
        },
      ),
    );
  }
}
