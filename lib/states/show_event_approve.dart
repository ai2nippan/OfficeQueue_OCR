import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:officeq_ocr/models/event_model.dart';
import 'package:officeq_ocr/models/user_model.dart';
import 'package:officeq_ocr/utility/my_constant.dart';
import 'package:officeq_ocr/utility/my_dialog.dart';
import 'package:officeq_ocr/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowEventApprove extends StatefulWidget {
  final EventModel eventModel;
  const ShowEventApprove({Key? key, required this.eventModel})
      : super(key: key);

  @override
  _ShowEventApproveState createState() => _ShowEventApproveState();
}

class _ShowEventApproveState extends State<ShowEventApprove> {
  EventModel? eventModel;
  String? idSub, dateSub, sub, xdesc, status;
  String? user, idUser, dept, position, name;
  List<UserModel> userModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventModel = widget.eventModel;
    checkIdSub();
    checkIdUser();
  }

  Future<Null> checkIdSub() async {
    idSub = eventModel!.idSub;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    idUser = preferences.getString('id')!;

    dept = preferences.getString('usertype')!;
    position = preferences.getString('occupation')!;
    name = preferences.getString('name')!;
    user = preferences.getString('user');

    String apiCheckIdUser =
        '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/getEventWhereIdSub.php?isAdd=true&idSub=$idSub';

    await Dio().get(apiCheckIdUser).then((value) {
      if (value.toString().trim() == 'null') {
        MyDialog().normalDialog(context, 'ไม่พบข้อมูล', 'ไม่พบรหัสพนักงานคะ');
      } else {
        for (var item in json.decode(value.data)) {
          EventModel eventModel = EventModel.fromMap(item);

          setState(() {
            dateSub = eventModel.dateSub;
            sub = eventModel.sub;
            xdesc = eventModel.xdesc;
            status = eventModel.status;
          });
        }
      }
    });
  }

  Future<Null> checkIdUser() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Event Approve'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              buildTitle(),
              buildDateEvent(),
              buildIdUser(),
              buildName(),
              buildDept(),
              buildPosition(),
              buildSubject(),
              buildDesc(),
              buildResult(),
            ],
          ),
        ),
      ),
    );
  }

  ShowTitle buildDateEvent() {
    return ShowTitle(
              title: 'วันที่ : $dateSub',
              textStyle: MyConstant().h2Style(),
            );
  }

  ShowTitle buildIdUser() {
    return ShowTitle(
      title: 'รหัสผู้ใช้ : $user',
      textStyle: MyConstant().h2Style(),
    );
  }

  ShowTitle buildResult() {
    return ShowTitle(
      title: 'ผลลัพธ์ : $status',
      textStyle: MyConstant().h2Style(),
    );
  }

  ShowTitle buildDesc() {
    return ShowTitle(
      title: 'รายละเอียด : $xdesc',
      textStyle: MyConstant().h2Style(),
    );
  }

  ShowTitle buildSubject() {
    return ShowTitle(
      title: 'เรื่อง : $sub',
      textStyle: MyConstant().h2Style(),
    );
  }

  ShowTitle buildPosition() {
    return ShowTitle(
      title: 'ตำแหน่ง : $position',
      textStyle: MyConstant().h2Style(),
    );
  }

  ShowTitle buildDept() {
    return ShowTitle(
      title: 'แผนก : $dept',
      textStyle: MyConstant().h2Style(),
    );
  }

  ShowTitle buildName() {
    return ShowTitle(
      title: 'ชื่อ : $name',
      textStyle: MyConstant().h2Style(),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'แจ้งผลการดำเนินการ',
      textStyle: MyConstant().h2Style(),
    );
  }
}
