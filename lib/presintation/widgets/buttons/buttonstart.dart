import 'package:flutter/material.dart';
class ButtonStart extends StatelessWidget {
  final Color onPrimary;
  final Color primary;
  final GestureTapCallback onPressed;
  final String text;
  final double minimumSizeX;
  final double minimumSizeY;
  final double paddingHorizontal;
  final double fontSize;
  final double radius;
  const ButtonStart({Key? key,
    required this.onPrimary,
    required this.primary,
    required this.onPressed,
    required this.text,
    required this.minimumSizeX,
    required this.minimumSizeY,
    required this.paddingHorizontal,
    required this.fontSize,
    required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            onPrimary: onPrimary,
            primary: primary,
            minimumSize: Size(minimumSizeX, minimumSizeY),
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),

          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          )),
    );
  }
}
