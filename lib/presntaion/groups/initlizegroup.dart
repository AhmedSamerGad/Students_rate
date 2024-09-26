import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/logic/users_cubit.dart';

import '../../constant.dart';

class InitlizeGroup extends StatefulWidget {
  const InitlizeGroup({super.key});

  @override
  State<InitlizeGroup> createState() => _InitlizeGroupState();
}

class _InitlizeGroupState extends State<InitlizeGroup> {
  var nameControllar = TextEditingController();
  var descriptionControllar = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  @override
  void dispose() {
    nameControllar.dispose();
    descriptionControllar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersCubit(),
      child: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {
          if (state is UsersLoading) {
            showProgressIndicator(context);
          } else if (state is GroupSuccessAdded) {
            context.read<UsersCubit>().fetchGroup();
            Navigator.pop(context);
            Navigator.pushNamed(context, groubScreen);
          } else if (state is GroupErrorAdded) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'add groub',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameControllar,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          label: const Text(
                            'group name',
                          ),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 16),
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'you should enter the name of group';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          name = value.trim();
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: descriptionControllar,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          label: const Text(
                            'description of group(optional)',
                          ),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 16),
                        ),
                        onFieldSubmitted: (value) {
                          description = value.trim();
                        },
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<UsersCubit>().addGroup(
                                name: nameControllar.text.trim(),
                                description: descriptionControllar.text.trim());
                          }
                        },
                        child: Text('set up'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
