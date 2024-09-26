import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/events.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial(DateTime.now()));
  late Database database;

  Future<void> initialize() async {
    await initializeDatabase();
    await loadEventsForSelectedDate(); // Load events for the initial date
    debugPrint('Initialization succeeded');
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(state.selectedDay, selectedDay)) {
      // Load events for the newly selected date
      List<Event> eventsForDay = await loadEventsForDate(selectedDay);

      // Replace the events for the selected day in the state
      state.events[
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] =
          eventsForDay;

      // Emit a new state with the updated events
      emit(CalendarSelectedDay(
        selectedDay: selectedDay,
        focusedDay: focusedDay,
        events: state.events,
      ));
      print('Emitted CalendarSelectedDay state: $state');
    }
  }

  List<Event> getEventsDay(DateTime selectedDay) {
    return state.events[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];
  }

  void addEvent(
      DateTime selectedDay, String eventName, TimeOfDay eventTime) async {
    // Mark as async
    List<Event> updatedEvents = state.events[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];

    // Insert the new event and get the updated list (await the result)
    List<Event> eventsWithIds = await insertRows(
        [Event(title: eventName, time: eventTime)], selectedDay);

    // Add the new event (with ID) to the existing list
    updatedEvents
        .addAll(eventsWithIds); // Use addAll to append the new event with ID

    state.events[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] =
        updatedEvents;

    emit(CalendarSelectedDay(
      selectedDay: state.selectedDay,
      focusedDay: state.focusedDay,
      events: state.events,
    ));
    print('Emitted CalendarSelectedDay state: $state');
  }

  Future<void> initializeDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = '$databasePath/calendarData.db';
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      db.execute(
          'CREATE TABLE Appoinetment(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, dateTime TEXT, eventData TEXT)');
    });
  }

  Future<List<Event>> insertRows(
      List<Event> events, DateTime selectedDay) async {
    emit(CalendarLoading(state.selectedDay, state.focusedDay, state.events));
    try {
      await database.transaction((txn) async {
        for (int i = 0; i < events.length; i++) {
          var event = events[i];
          String eventJson = jsonEncode(event.toJson());

          String formattedDateTime =
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day)
                  .toUtc()
                  .toIso8601String();
          int insertedID = await txn.insert('Appoinetment', {
            'title': event.title,
            'dateTime': formattedDateTime,
            'eventData': eventJson
          });
          debugPrint(' insertedId : $insertedID');
          events[i] = event.copyWith(id: insertedID);

          debugPrint('Field added');
        }
      });

      // Return the updated events list with IDs
      return events;
    } catch (onError) {
      debugPrint(onError.toString());
      emit(Erroraccured(state.focusedDay, state.selectedDay, state.events));
      return []; // Return an empty list in case of errors
    }
  }

  // Load events for the currently selected date
  Future<void> loadEventsForSelectedDate() async {
    List<Event> events = await loadEventsForDate(state.selectedDay);
    // Update the events map in the state
    if (!state.events.containsKey(DateTime(state.selectedDay.year,
        state.selectedDay.month, state.selectedDay.day))) {
      state.events[DateTime(state.selectedDay.year, state.selectedDay.month,
          state.selectedDay.day)] = [];
    }
    state.events[DateTime(state.selectedDay.year, state.selectedDay.month,
        state.selectedDay.day)] = events;
    emit(GetAllLocalDayDate(state.selectedDay, state.focusedDay, state.events));
    print('Emitted GetAllLocalDayDate state: $state');
  }

  // Helper function to load events for any given date
  Future<List<Event>> loadEventsForDate(DateTime selectedDate) async {
    try {
      print('Loading events for date: $selectedDate');

      // Format selectedDate to match how it's stored in the database
      String formattedDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
              .toUtc()
              .toIso8601String();

      // Query the database for events on the selected date
      List<Map> rows = await database.query(
        'Appoinetment',
        where: 'dateTime = ?',
        whereArgs: [formattedDate],
      );

      print('Number of rows fetched: ${rows.length}');
      List<Event> eventsForDate = [];
      for (var row in rows) {
        String title = row['title'];
        String eventJson = row['eventData'];
        Map<String, dynamic> eventMap = jsonDecode(eventJson);

        // Correctly parse hour and minute as integers
        int hour = eventMap['time']['hour'] as int;
        int minute = eventMap['time']['minute'] as int;

        TimeOfDay eventTime = TimeOfDay(hour: hour, minute: minute);
        Event event = Event(title: title, time: eventTime);
        eventsForDate.add(event);
      }

      print('Events for date: $eventsForDate');
      return eventsForDate;
    } catch (e) {
      debugPrint('Error loading events: ${e.toString()}');
      return []; // Return an empty list in case of errors
    }
  }

  void deleteElements(DateTime selectedDay, Event eventToDalete) {
    List<Event> events = state.events[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
        [];
    events.remove(eventToDalete);
    state.events[
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] =
        events;
    deleteFromDatabase(eventToDalete);
    emit(CalendarSelectedDay(
        selectedDay: state.selectedDay,
        focusedDay: state.focusedDay,
        events: state.events));
    debugPrint('Emitted CalendarSelectedDay state: $state');
  }

  Future<void> deleteFromDatabase(Event eventToDalete) async {
    try {
      if (eventToDalete.id != null) {
        await database.delete('Appoinetment',
            where: 'id = ? ', whereArgs: [eventToDalete.id]);
        debugPrint('Event deleted From Database');
      } else {
        debugPrint('Cannot delete event without an ID');
      }
    } catch (e) {
      debugPrint('Error Deleting ${e.toString()}');
    }
  }
}
