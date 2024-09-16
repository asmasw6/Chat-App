import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String barTitle;
  Widget? primaryAction;
  Widget? secondaryAction;
  double? fontSize;

  late double deviceHight;
  late double deviceWidth;

  TopBar(
    this.barTitle, {
    this.primaryAction,
    this.secondaryAction,
    this.fontSize =30,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    deviceHight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }

  Widget buildUI() {
    return  Container(
      height: deviceHight * .10,
      width: deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          titleBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget titleBar() {
    return Text(
      barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
