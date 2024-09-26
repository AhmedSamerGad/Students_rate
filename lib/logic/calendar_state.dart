part of 'calendar_cubit.dart';

abstract class CalendarState {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Map<DateTime, List<Event>> events;

  CalendarState(this.selectedDay, this.focusedDay, this.events);
}

class CalendarInitial extends CalendarState {
  CalendarInitial(DateTime focusedDay) : super(focusedDay, focusedDay, {});
}

class CalendarSelectedDay extends CalendarState {
  CalendarSelectedDay({
    required DateTime selectedDay,
    required DateTime focusedDay,
    required Map<DateTime, List<Event>> events,
  }) : super(selectedDay, focusedDay, events);
}

class AddNewDateSussessed extends CalendarState {
  AddNewDateSussessed(super.selectedDay, super.focusedDay, super.events);
}

class CalendarLoading extends CalendarState {
  CalendarLoading(DateTime selectedDay, DateTime focusedDay,
      Map<DateTime, List<Event>> events)
      : super(selectedDay, focusedDay, events);
}

class Erroraccured extends CalendarState {
  Erroraccured(super.selectedDay, super.focusedDay, super.events);
}

class GetAllLocalDayDate extends CalendarState {
  GetAllLocalDayDate(super.selectedDay, super.focusedDay, super.events);
}
