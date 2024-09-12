import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color? bdColor; // borderLine nullable로 둠
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final double height;
  final Function(int) onItemTapped;

  WideButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.onItemTapped,
    this.bdColor,
    this.width = 200,
    this.height = 50,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        border: bdColor != null
            ? Border.all(color: bdColor!) // bdColor가 null이 아닐 때만 적용,
            : null,
        borderRadius: BorderRadius.circular(48),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 65,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}