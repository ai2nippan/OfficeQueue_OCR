import 'package:flutter/material.dart';
import 'package:officeq_ocr/states/customtablecalendar.dart';
import 'package:officeq_ocr/states/show_calendar.dart';
import 'package:officeq_ocr/states/show_calendar_basic.dart';
import 'package:officeq_ocr/states/showbook.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main menu'),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                // builder: (context) => ShowCalendar(),
                // builder: (context) => CustomTableCalendar(),
                builder: (context) => ShowBook(),
              ),
            ),
            child: ListTile(
              title: Text('จอง (Book)'),
            ),
          ),
          ListTile(
            title: Text('ผลการจอง (Book Result)'),
          ),
          ListTile(
            title: Text('อนุมัติ (Approve)'),
          ),
        ],
      ),
    );
  }
}
