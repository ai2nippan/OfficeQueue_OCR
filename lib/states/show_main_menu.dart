import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:officeq_ocr/models/event_model.dart';
import 'package:officeq_ocr/models/user_model.dart';
import 'package:officeq_ocr/states/customtablecalendar.dart';
import 'package:officeq_ocr/states/list_events_creator.dart';
import 'package:officeq_ocr/states/list_events_manage.dart';
import 'package:officeq_ocr/states/show_calendar.dart';
import 'package:officeq_ocr/states/show_calendar_basic.dart';
import 'package:officeq_ocr/states/showbook.dart';
import 'package:officeq_ocr/utility/my_constant.dart';
import 'package:officeq_ocr/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<UserModel> userModels = [];
  bool load = true;
  bool? haveData;
  String? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
  }

  Future<Null> loadUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user = preferences.getString('user')!;
    // position = preferences.getString('occupation');

    String apiGetUser =
        '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiGetUser).then((value) {
      if (value.toString().trim() == 'null') {
        // No data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have data
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);

          setState(() {
            load = false;
            haveData = true;

            position = model.occupation;
            
            userModels.add(model);
          });
        }
      }
    });
  }

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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListEventsCreator(),
            )),
            title: Text('ผลการจอง (Book Result)'),
          ),
          ListTile(
            onTap: () {
              print('position : $position');
              if (position == 'Manager') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListEventsManage(),
                  ),
                );
              } else {
                MyDialog().normalDialog(
                    context, 'เข้าไม่ได้', 'สิทธิ์ของคุณไม่สามารถเข้าได้คะ');
              }
            },
            title: Text('อนุมัติ (Approve)'),
          ),
        ],
      ),
    );
  }
}
