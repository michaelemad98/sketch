import 'package:flutter/material.dart';
class ContainerOrder extends StatelessWidget {
        final String text;
        final GestureTapCallback onPressed;
  const ContainerOrder({Key? key,required this.text,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16 ,right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(child: Text("$text"),),
    ));
  }
}
