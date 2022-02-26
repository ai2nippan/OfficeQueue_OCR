import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:officeq_ocr/models/event_model.dart';
import 'package:officeq_ocr/states/show_make_approve.dart';
import 'package:officeq_ocr/utility/my_constant.dart';
import 'package:officeq_ocr/utility/my_dialog.dart';
import 'package:officeq_ocr/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListEventsManage extends StatefulWidget {
  const ListEventsManage({Key? key}) : super(key: key);

  @override
  _ListEventsManageState createState() => _ListEventsManageState();
}

class _ListEventsManageState extends State<ListEventsManage> {
  List<EventModel> eventModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus() async {

    if (eventModels.length != null) {
      eventModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String dept = preferences.getString('usertype')!;
    String status = 'Waiting';

    String apiStatus =
        '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/getEventWhereStatus.php?isAdd=true&usertype=$dept&status=$status';

    await Dio().get(apiStatus).then((value) {
      if (value.toString().trim() == 'null') {
        MyDialog()
            .normalDialog(context, 'ไม่พบข้อมูล', 'ไม่มีรายการให้อนุมัติคะ');
      } else {
        for (var item in json.decode(value.data)) {
          EventModel model = EventModel.fromMap(item);

          setState(() {
            eventModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage List'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => buildEventStatus(constraints),
      ),
    );
  }

  ListView buildEventStatus(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: eventModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowMakeApprove(eventModel: eventModels[index],),
          )).then((value) {
            checkStatus();
          });

         
        },
        child: Card(
          child: Row(
            children: [
              Container(
                width: constraints.maxWidth * 0.5 - 5,
                height: constraints.maxWidth * 0.2,
                padding: EdgeInsets.all(4),
                child: Column(
                  children: [
                    ShowTitle(
                      // หัวข้อ
                      // title: 'หัวข้อ : ${eventModels[index].sub}',
                      title: '${eventModels[index].sub}',
                      textStyle: MyConstant().h2Style(),
                    ),
                    ShowTitle(
                      //title: 'รายละเอียด : ${eventModels[index].xdesc}',
                      title: '${eventModels[index].xdesc}',
                      textStyle: MyConstant().h2Style(),
                    ),
                  ],
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.5 - 8,
                height: constraints.maxWidth * 0.2,
                padding: EdgeInsets.all(4),
                child: Column(
                  children: [
                    ShowTitle(
                      // Status
                      title: '${eventModels[index].status}',
                      textStyle: MyConstant().h2Style(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
