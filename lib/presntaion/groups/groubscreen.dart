import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/constant.dart';
import 'package:news_app/logic/users_cubit.dart';

import '../../model/groubs.dart';

class Groubscreen extends StatefulWidget {
  const Groubscreen({super.key});

  @override
  State<Groubscreen> createState() => _GroubscreenState();
}

class _GroubscreenState extends State<Groubscreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersState>(
      listener: (context, state) {
        if (state is UsersSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        // Consider handling GroupErrorAdded state here for specific error messages
        if (state is UsersLoading) {
          showProgressIndicator(context);
        }
      },
      builder: (context, state) {
        if (state is UsersInitial) {
          BlocProvider.of<UsersCubit>(context).fetchGroup();
          return const Center(child: CircularProgressIndicator());
        } else if (state is GroupsLoaded) {
          // Use GroupsLoaded state here
          final groups = state.groups;
          return Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Groups',
                style: GoogleFonts.roboto(),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, addNumbers);
                  },
                  icon: const Icon(Icons.group),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: groups.isNotEmpty
                  ? ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return buildGrougs(groups[index]);
                      },
                    )
                  : const Center(child: Text('No groups available')),
            ),
          );
        } else if (state is UsersError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget buildGrougs(Groups groups) {
    return InkWell(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage:
                groups.picture != null ? AssetImage(groups.picture!) : null,
          ),

          title: Text(
            groups.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            groups.description ?? "",
            style: Theme.of(context).textTheme.caption,
          ), // Handle potential null
          titleTextStyle: GoogleFonts.cairo(letterSpacing: 2),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, likeChat, arguments: groups);
      },
    );
  }
}
