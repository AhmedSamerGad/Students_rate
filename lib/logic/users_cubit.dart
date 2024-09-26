// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:news_app/model/groubs.dart';
import 'package:news_app/model/users.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());
  var firebaseStore = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  void initlizer() {
    fetchGroup();
  }

  Future<void> addAdmin() async {
    emit(UsersLoading());
    try {
      if (auth.currentUser != null) {
        Users user = Users(auth.currentUser!.uid, 'ahmed',
            auth.currentUser!.phoneNumber!, [], UserType.admin);
        await firebaseStore.collection('admin').doc(user.id).set(user.toMap());
        emit(const UsersSuccess("Success add admin"));
      }
    } catch (e) {
      emit(UsersError('Error adding admin: ${e.toString()}'));
    }
  }

  Future<void> addGroup({
    required String name,
    String? description,
  }) async {
    emit(UsersLoading());
    print('Emitting UsersLoading');
    try {
      Groups groups =
          Groups(id: '', name: name, description: description, members: []);
      DocumentReference documentReference = await firebaseStore
          .collection('admin')
          .doc(auth.currentUser!.uid)
          .collection('groups')
          .add(groups.toMap());
      groups = groups.copyWith(id: documentReference.id);
      emit(const GroupSuccessAdded('group added successfuly'));
      print('Emitting GroupSuccessAdded');
    } catch (e) {
      emit(GroupErrorAdded('error in adding group : ${e.toString()}'));
    }
  }

  Future<List<Groups>> fetchGroup() async {
    emit(UsersLoading());
    print('Emitting UsersLoading (fetchGroup)');
    try {
      QuerySnapshot querySnapshot = await firebaseStore
          .collection('admin')
          .doc(auth.currentUser!.uid)
          .collection('groups')
          .get();
      List<Groups> groups = querySnapshot.docs.map((doc) {
        return Groups.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      emit(GroupsLoaded(groups));
      print('Emitting GroupsLoaded');
      return groups;
    } catch (e) {
      emit(GroupErrorAdded('error while fetching groups : ${e.toString()} '));
      return [];
    }
  }

  Future<List<Contact>> filterContactsWithFirebase() async {
    List<Contact> filteredContacts = [];
    List<String> firebasePhoneNumbers = await getPhoneNumbersFromFirebase();
    List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: false);

    for (Contact contact in contacts) {
      for (Phone phone in contact.phones) {
        if (firebasePhoneNumbers.contains(phone.number)) {
          filteredContacts.add(contact);
          break;
        }
      }
    }

    return filteredContacts;
  }

  Future<List<String>> getPhoneNumbersFromFirebase() async {
    List<String> phoneNumbers = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('PhoneNumbers').get();
    for (var doc in snapshot.docs) {
      phoneNumbers.add(doc.id);
    }
    return phoneNumbers;
  }

  Users? users;
  set setUserType(UserType value) {
    users!.userType = value;
    updateUserType();
  }

  Future<void> updateUserType() async {
    emit(UsersLoading());
    try {
      firebaseStore
          .collection('admin')
          .doc(auth.currentUser!.uid)
          .update({'userType': UserType.values});
      // here i wanne to add state to manage this function
    } catch (e) {}
  }
}
