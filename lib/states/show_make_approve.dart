import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:officeq_ocr/models/event_model.dart';
import 'package:officeq_ocr/models/user_model.dart';
import 'package:officeq_ocr/utility/my_constant.dart';
import 'package:officeq_ocr/utility/my_dialog.dart';
import 'package:officeq_ocr/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMakeApprove extends StatefulWidget {
  final EventModel eventModel;
  // final String status;
  // const ShowMakeApprove({Key? key,required this.eventModel, required this.status}) : super(key: key);
  const ShowMakeApprove({Key? key, required this.eventModel}) : super(key: key);

  @override
  _ShowMakeApproveState createState() => _ShowMakeApproveState();
}

class _ShowMakeApproveState extends State<ShowMakeApprove> {
  String? idSub, idUser, datesub, name, dept, position, sub, xdesc;
  String? status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idUser = widget.eventModel.idUser;
    idSub = widget.eventModel.idSub;
    datesub = widget.eventModel.dateSub;
    name = widget.eventModel.name;
    sub = widget.eventModel.sub;
    xdesc = widget.eventModel.xdesc;
    loadUserData();
  }

  Future<Null> loadUserData() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();

    String apiGetUser = '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/getUserWhereidUser.php?isAdd=true&idUser=$idUser';

    await Dio().get(apiGetUser).then((value) {
      
      if (value.toString().trim() == 'null' ) {
        MyDialog().normalDialog(context, 'ไม่พบข้อมูล', 'ไม่พบรหัสพนักงาน');
      } else {
        for (var item in json.decode(value.data)) {
          
          UserModel model = UserModel.fromMap(item);

          setState(() {
            dept = model.usertype;
            position = model.occupation;
          });

        }
      }

    });

    setState(() {
      // dept = preferences.getString('usertype');
      // position = preferences.getString('occupation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Make Approve'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              buildTitle(),
              buildDateIn(),
              buildName(),
              buildDept(),
              buildPosition(),
              buildSubject(),
              buildDesc(),
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  ShowTitle buildDateIn() {
    return ShowTitle(
      title: 'วันที่เข้า : $datesub',
      textStyle: MyConstant().h2Style(),
    );
  }

  Future<Null> buttonApprove() async {
    status = 'Approve';

    String apiUpdateApprove =
        '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/UpdateStatusWhereIdSub.php?isAdd=true&idSub=$idSub&status=$status';

    await Dio().get(apiUpdateApprove).then((value) {
      if (value.toString().trim() == 'null') {
        MyDialog().normalDialog(context, 'การอัพเดท', 'คุณไม่ได้อัพเดท');
      } else {
        MyDialog().normalDialog(context, 'การอัพเดท', 'อนุมัติเรียบร้อย');
      }
    });
  }

  Future<Null> buttonNotApprove() async {
    status = 'NotApprove';

    String apiUpdateApprove =
        '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/UpdateStatusWhereIdSub.php?isAdd=true&idSub=$idSub&status=$status';

    await Dio().get(apiUpdateApprove).then((value) {
      if (value.toString().trim() == 'null') {
        MyDialog().normalDialog(context, 'การอัพเดท', 'คุณไม่ได้อัพเดท');
      } else {
        MyDialog().normalDialog(context, 'การอัพเดท', 'ไม่อนุมัติ');
      }
    });
  }

  Row buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            buttonApprove();
            // print('Approve');
            Navigator.pop(context);
          },
          child: Text('Approve'),
        ),
        ElevatedButton(
          onPressed: () {
            // print('Not Approve');
            buttonNotApprove();
            Navigator.pop(context);
          },
          child: Text('Not Approve'),
        ),
      ],
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
      title: 'หัวข้อ : $sub',
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
      title: 'อนุญาติให้ดำเนินการหรือไม่ ?',
      textStyle: MyConstant().h2Style(),
    );
  }
}
