import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

///
///
///
class OcrTextDetail extends StatefulWidget {
  final OcrText ocrText;

  OcrTextDetail(this.ocrText);

  @override
  _OcrTextDetailState createState() => _OcrTextDetailState();
}

///
///
///
class _OcrTextDetailState extends State<OcrTextDetail> {
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    String ot = widget.ocrText.value;
    // print(widget.ocrText.value);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue Details'),
      ),
      body: Card(
        child: ListView(
          children: <Widget>[
            ListTile(
              // title: Text(widget.ocrText.value),
              // subtitle: const Text('Value'),
              title: Text('จอง (Book)'),
            ),
            ListTile(
              // title: Text(widget.ocrText.language),
              // subtitle: const Text('Language'),
              title: Text('ผลการจอง (Book Result)'),
            ),
            ListTile(
              // title: Text(widget.ocrText.top.toString()),
              // subtitle: const Text('Top'),
              title: Text('อนุมัติ (Approve)'),
            ),
            // ListTile(
            //   title: Text(widget.ocrText.bottom.toString()),
            //   subtitle: const Text('Bottom'),
            // ),
            // ListTile(
            //   title: Text(widget.ocrText.left.toString()),
            //   subtitle: const Text('Left'),
            // ),
            // ListTile(
            //   title: Text(widget.ocrText.right.toString()),
            //   subtitle: const Text('Right'),
            // ),
          ],
        ),
      ),
    );
  }
}