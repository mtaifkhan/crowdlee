import 'package:flutter/material.dart';

class Followbutton extends StatelessWidget {
  final Function()? fuction;
  final String text;
  final Color textColor;
  final Color bordercolor;
  final Color backgroundcolor;
  const Followbutton({
    Key? key,
    required this.text,
    required this.fuction,
    required this.textColor,
    required this.bordercolor,
    required this.backgroundcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 45.0,
      padding: const EdgeInsets.only(top: 2.0),
      child: TextButton(
          onPressed: fuction,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: bordercolor)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
