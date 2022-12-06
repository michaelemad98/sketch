import 'package:flutter/material.dart';
class ButtonOrder extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Color? backgroundColor;
  const ButtonOrder({Key? key,required this.onPressed,required this.text,this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child:ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: backgroundColor,
            minimumSize: Size(100,50),
            padding: EdgeInsets.symmetric(horizontal: 16),
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
          ),
          onPressed: onPressed, child:  Text(
        text,
        style: TextStyle(fontSize: 16),
      )),
    );
  }
}
