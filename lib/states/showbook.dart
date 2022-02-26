import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:officeq_ocr/states/customtablecalendar.dart';
import 'package:officeq_ocr/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:table_calendar/table_calendar.dart';

import '../utility/appcolors.dart';
import '../utility/my_constant.dart';

class ShowBook extends StatefulWidget {
  const ShowBook({Key? key}) : super(key: key);

  @override
  _ShowBookState createState() => _ShowBookState();
}

class _ShowBookState extends State<ShowBook> {
  final todaysDate = DateTime.now();
  var _focusedCalendarDate = DateTime.now();
  final _initialCalendarDate = DateTime(2000);
  final _lastCalendarDate = DateTime(2060);
  DateTime? selectedCalendarDate;
  final titleController = TextEditingController();
  final descpController = TextEditingController();
  var formatter = DateFormat('dd-MM-yyyy');

  late Map<DateTime, List<MyEvents>> mySelectedEvents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCalendarDate = _focusedCalendarDate;
    mySelectedEvents = {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descpController.dispose();
  }

  List<MyEvents> _listOfDayEvents(DateTime dateTime) {
    return mySelectedEvents[dateTime] ?? [];
  }

  Future<Null> InsertSubject(
      {String? dateSub, String? sub, String? xdesc, String? status}) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id')!;
    String name = preferences.getString('name')!;

    String apiInsertSubject =
        '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/InsertSubject.php?isAdd=true&idUser=$idUser&name=$name&dateSub=$dateSub&sub=$sub&xdesc=$xdesc&status=$status';
    // print('Insert DB1');
    await Dio().get(apiInsertSubject).then((value) async {
      if (value.toString().trim() == 'null') {
        MyDialog()
            .normalDialog(context, 'บันทึกข้อมูล', 'ไม่สามารถบันทึกข้อมูลได้');
      } else {
        MyDialog().normalDialog(context, 'บันทึกข้อมูล', 'บันทึกเรียบร้อย');
      }
    });
  }

  Future<Null> _addEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('รายการใหม่'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextField(controller: titleController, hint: 'กรอกหัวข้อ'),
            SizedBox(
              height: 20.0,
            ),
            buildTextField(controller: descpController, hint: 'กรอกรายละเอียด'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty &&
                  descpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('กรุณาใส่ชื่อเรื่อง และรายละเอียด'),
                    duration: Duration(seconds: 3),
                  ),
                );
                // Navigator.pop(context);
                return;
              } else {
                // print('Before statexxxxx');
                // print('mySelectedEvents : ${mySelectedEvents[selectedCalendarDate]}');
                setState(() {
                  if (mySelectedEvents[selectedCalendarDate] != null) {
                    // Insert data to DB
                    // print('Add db');
                    // InsertSubject(
                    //     dateSub: selectedCalendarDate.toString(),
                    //     sub: titleController.text,
                    //     xdesc: descpController.text,
                    //     status: 'wait');

                    mySelectedEvents[selectedCalendarDate]?.add(MyEvents(
                        eventTitle: titleController.text,
                        eventDescp: descpController.text));
                  } else {
                    mySelectedEvents[selectedCalendarDate!] = [
                      MyEvents(
                          eventTitle: titleController.text,
                          eventDescp: descpController.text)
                    ];
                  }

                  // print('selectedCalendarDate : ${formatter.format(selectedCalendarDate!)}');  
                  InsertSubject(
                        //dateSub: selectedCalendarDate.toString(),
                        dateSub: formatter.format(selectedCalendarDate!).toString(),
                        sub: titleController.text,
                        xdesc: descpController.text,
                        status: 'Waiting');

                });

                titleController.clear();
                descpController.clear();

                Navigator.pop(context);
                return;
              }
            },
            child: Text('เพิ่ม'),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      {String? hint, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: hint ?? '',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.eggPlant, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.eggPlant, width: 1.5),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบจอง'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addEventDialog(),
        label: Text('เพิ่มรายการ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(8.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(color: AppColors.blackCoffee, width: 2.0),
              ),
              child: TableCalendar(
                focusedDay: _focusedCalendarDate,
                firstDay: _initialCalendarDate,
                lastDay: _lastCalendarDate,
                calendarFormat: CalendarFormat.month,
                weekendDays: [DateTime.sunday, 6],
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekHeight: 40.0,
                rowHeight: 60.0,
                eventLoader: _listOfDayEvents,
                headerStyle: HeaderStyle(
                  titleTextStyle:
                      TextStyle(color: AppColors.babyPowder, fontSize: 20.0),
                  decoration: BoxDecoration(
                      color: AppColors.eggPlant,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  formatButtonTextStyle:
                      TextStyle(color: AppColors.ultraRed, fontSize: 16.0),
                  formatButtonDecoration: BoxDecoration(
                    color: AppColors.babyPowder,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.babyPowder,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.babyPowder,
                    size: 28,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: AppColors.ultraRed),
                ),
                calendarStyle: CalendarStyle(
                  weekendTextStyle: TextStyle(color: AppColors.ultraRed),
                  todayDecoration: BoxDecoration(
                      color: AppColors.blackCoffee, shape: BoxShape.circle),
                ),
                selectedDayPredicate: (currentSelectedDate) {
                  return (isSameDay(selectedCalendarDate, currentSelectedDate));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selectedCalendarDate, selectedDay)) {
                    setState(() {
                      selectedCalendarDate = selectedDay;
                      _focusedCalendarDate = focusedDay;
                      
                      // print('selectedCalendarDate : $selectedCalendarDate');
                      print('selectedCalendarDate : ${formatter.format(selectedCalendarDate!)}');
                      print('_focusedCalendarDate : $_focusedCalendarDate');
                      
                    });
                  }
                },
              ),
            ),
            ..._listOfDayEvents(selectedCalendarDate!).map(
              (myEvents) => ListTile(
                leading: Icon(
                  Icons.done,
                  color: AppColors.eggPlant,
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('หัวข้อ: ${myEvents.eventTitle}'),
                ),
                subtitle: Text('รายละเอียด: ${myEvents.eventDescp}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyEvents {
  final String eventTitle;
  final String eventDescp;

  MyEvents({required this.eventTitle, required this.eventDescp});

  @override
  String toString() => eventTitle;
}
