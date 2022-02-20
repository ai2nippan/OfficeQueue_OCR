import 'package:flutter/material.dart';
import 'package:officeq_ocr/states/range_example.dart';
import 'package:officeq_ocr/states/show_calendar_basic.dart';
import 'package:officeq_ocr/states/show_calendar_event.dart';

import 'complex_example.dart';
import 'multi_example.dart';

class ShowCalendar extends StatefulWidget {
  const ShowCalendar({ Key? key }) : super(key: key);

  @override
  _ShowCalendarState createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Basics'),
              onPressed: () => Navigator.push(
                context,
                //MaterialPageRoute(builder: (_) => TableBasicsExample()),
                MaterialPageRoute(builder: (_) => ShowCalendarBasic()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Range Selection'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableRangeExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Events'),
              onPressed: () => Navigator.push(
                context,
                // MaterialPageRoute(builder: (_) => TableEventsExample()),
                MaterialPageRoute(builder: (_) => ShowCalendarEvent()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Multiple Selection'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableMultiExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Complex'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableComplexExample()),
                
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}