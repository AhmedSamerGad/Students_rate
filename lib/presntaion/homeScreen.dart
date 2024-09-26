import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/logic/calendar_cubit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarCubit, CalendarState>(
      listenWhen: (previous, current) => previous.events != current.events,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CalendarLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Appoientments'),
            ),
            body: Column(
              children: [
                BlocBuilder<CalendarCubit, CalendarState>(
                  builder: (context, state) {
                    return TableCalendar(
                      focusedDay: state.focusedDay,
                      firstDay: DateTime.utc(2020, 6, 20),
                      lastDay: DateTime.utc(2030, 6, 20),
                      onDaySelected: (selectedDay, focusedDay) {
                        BlocProvider.of<CalendarCubit>(context)
                            .onDaySelected(selectedDay, focusedDay);
                      },
                      eventLoader: (day) {
                        return context.read<CalendarCubit>().getEventsDay(day);
                      },
                      calendarStyle: const CalendarStyle(markersMaxCount: 1),
                      selectedDayPredicate: (day) =>
                          isSameDay(state.selectedDay, day),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Builder(
                    // Use Builder to access eventsForDay
                    builder: (context) {
                      final eventsForDay = context
                          .read<CalendarCubit>()
                          .getEventsDay(state.selectedDay);
                      return ListView.builder(
                        itemCount: eventsForDay.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    eventsForDay[index].title,
                                    style: GoogleFonts.cairo(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 70,
                                  ),
                                  Text(
                                    eventsForDay[index].time!.format(context),
                                    style: GoogleFonts.cairo(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        context
                                            .read<CalendarCubit>()
                                            .deleteElements(state.selectedDay,
                                                eventsForDay[index]);
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                buildAddEvents(context, state.selectedDay)
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildAddEvents(context, selectedDay) {
    TimeOfDay? selectedTime;
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, build) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'add Events',
                              style: GoogleFonts.cairo(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: textController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Event Name'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  selectedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                },
                                child: Text(selectedTime != null
                                    ? 'selected Time : ${selectedTime!.format(context)}'
                                    : 'Choose time ')),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (textController.text.isNotEmpty &&
                                      selectedTime != null) {
                                    context.read<CalendarCubit>().addEvent(
                                        selectedDay,
                                        textController.text,
                                        selectedTime!);
                                    Navigator.pop(context);
                                    textController.clear();
                                  }
                                },
                                child: const Text('save'))
                          ],
                        ),
                      ),
                    );
                  });
                });
          },
          child: const Icon(Icons.add)),
    );
  }
}
