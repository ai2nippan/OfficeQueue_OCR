import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:officeq_ocr/models/event_model.dart';
import 'package:officeq_ocr/models/user_model.dart';
import 'package:officeq_ocr/states/show_event_approve.dart';
import 'package:officeq_ocr/utility/my_constant.dart';
import 'package:officeq_ocr/utility/my_dialog.dart';
import 'package:officeq_ocr/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListEventsCreator extends StatefulWidget {
  // final UserModel userModel;
  // const ListEventsCreator({Key? key, required this.userModel})
  // : super(key: key);

  const ListEventsCreator({Key? key}) : super(key: key);

  @override
  _ListEventsCreatorState createState() => _ListEventsCreatorState();
}

class _ListEventsCreatorState extends State<ListEventsCreator> {
  UserModel? userModel;
  bool load = true;
  bool? havedat;
  List<EventModel> eventModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userModel = widget.userModel;
    loadEvent();
  }

  Future<Null> loadEvent() async {

    // String idUser = userModel!.id;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String idUser = preferences.getString('id')!;

    String apiGetEvent =
        '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/getEventWhereIdUser.php?isAdd=true&idUser=$idUser';

    await Dio().get(apiGetEvent).then((value) {
      if (value.toString().trim() == 'null') {
        // No data
        setState(() {
          load = false;
          havedat = false;
        });
      } else {
        // Have data
        for (var item in json.decode(value.data)) {
          EventModel model = EventModel.fromMap(item);

          setState(() {
            load = false;
            havedat = true;

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
        title: Text('รายการจอง '),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => buildEventListView(constraints),
      ),
    );
  }

  ListView buildEventListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: eventModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          // print('Event ListView');

          if (eventModels[index].status == 'Approve') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShowEventApprove(eventModel: eventModels[index],),
              ),
            );
          } else {
            MyDialog().normalDialog(
                context, 'เข้าไม่ได้', 'รายการนี้กำลังคอยการอนุมัติ อยู่คะ');
          }
        },
        child: Card(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                // width: constraints.maxWidth * 0.5 - 8,
                width: constraints.maxWidth * 0.5 - 5,
                // height: constraints.maxWidth * 0.4,
                height: constraints.maxWidth * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTitle(
                      // title: 'หัวข้อ : ${eventModel[index].sub}',
                      title: '${eventModels[index].sub}',
                      textStyle: MyConstant().h2Style(),
                    ),
                    ShowTitle(
                      // title: 'รายละเอียด : ${eventModel[index].xdesc}',
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
