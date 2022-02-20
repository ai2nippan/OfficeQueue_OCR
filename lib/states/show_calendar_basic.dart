import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utility/utils.dart';



class ShowCalendarBasic extends StatefulWidget {
  const ShowCalendarBasic({Key? key}) : super(key: key);

  @override
  _ShowCalendarBasicState createState() => _ShowCalendarBasicState();
}

class _ShowCalendarBasicState extends State<ShowCalendarBasic> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Calendar'),
      ),
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use 'selectDayPredicate' to determine which day is currently selected.
          // If this returns true, then 'day' will be marked as selected.

          // Using 'isSameDay' is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call 'setState()' when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call 'setState()' when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call 'setState()' here
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
