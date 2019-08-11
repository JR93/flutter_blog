

import 'package:flutter/widgets.dart';
import 'package:zhiku/common/consts.dart';

class EmptyTip extends StatelessWidget {
  final String text;

  EmptyTip({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          text,
          style: TextStyle(color: GREY_COLOR, fontSize: 14.0,),
        ),
      ),
    );
  }
}