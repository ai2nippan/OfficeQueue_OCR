import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:officeq_ocr/models/user_model.dart';
import 'package:officeq_ocr/states/show_main_menu.dart';
// import 'package:officeq_ocr/models/user_model.dart';
import 'package:officeq_ocr/utility/my_constant.dart';
import 'package:officeq_ocr/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// @immutable
class Authen extends StatefulWidget {
  final OcrText ocrText;
  // const Authen({ Key? key, this.ocrText }) : super(key: key);

  Authen(this.ocrText);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {

   

  @override
  void initState() {
    super.initState();

    checkAuthen(user: widget.ocrText.value);
    print('ocrText : ${widget.ocrText.value}');
  }

  Future<Null> checkAuthen({String? user}) async {
    String apiCheckAuthen = '${MyConstant.domain}/Mobile/Flutter2/Train/officequeue_ocr/php/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiCheckAuthen).then((value) async {
      // return null;
      print('## value for API ==> $value');

      if (value.toString().trim() == 'null') {
        MyDialog().normalDialog(context, 'ผู้ใช้ไม่ถูกต้อง', 'ไม่พบข้อมูล $user');
      } else {
        // MyDialog().normalDialog(context, 'ผู้ใช้ถูกต้อง', 'พบข้อมูล $user');

        for (var item in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(item);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('id', userModel.id);
          preferences.setString('usertype', userModel.usertype);
          preferences.setString('occupation', userModel.occupation);
          preferences.setString('user', userModel.user);
          preferences.setString('name', userModel.name);

        }
        

        Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu(),));

        // for (var item in json.decode(value.data)) {
        //   UserModel userModel = UserModel.fromMap(item);
        //   if () {
            
        //   }
        // }
      }

    });

  }
  

  

  @override
  Widget build(BuildContext context) {
    // String ot = widget.ocrText.toString();
    // String user = widget.ocrText.value;
    // checkAuthen(user: widget.ocrText.value);
    return Scaffold(
      appBar: AppBar(title: Text('กำลังตรวจสอบ...'),),
    );
  }
}