import 'package:flutter/material.dart';

class Event {
  final String title;
  TimeOfDay? time;
  DateTime? dateTime;
  int? id;

  Event({this.id, required this.title, required this.time, this.dateTime});
  @override
  String toString() => 'Event(title: $title, time: $time,date:$dateTime)';
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': {
        'hour': time?.hour,
        'minute': time?.minute,
      }
    };
  }

  Event copyWith({
    String? title,
    TimeOfDay? time,
    int? id,
  }) {
    return Event(
      title: title ?? this.title,
      time: time ?? this.time,
      id: id ?? this.id,
    );
  }
}
