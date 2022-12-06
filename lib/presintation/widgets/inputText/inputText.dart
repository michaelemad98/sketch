import 'package:flutter/material.dart';

class DefaultTextInput extends StatelessWidget {
  TextEditingController tec;
  String hintText;
  final IconButton? suffixIcon;
  final bool obscureText ;
  DefaultTextInput({Key? key,required this.tec,required this.hintText,required this.obscureText,this.suffixIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.only(left: 25,top: 5,right: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.pink),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
        child: TextField(
        controller: tec,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText:hintText,
            border: InputBorder.none,
            suffixIcon:suffixIcon,
        ),
      ),
    );
  }
}
class TextInputD extends StatelessWidget {
  TextEditingController tec;
  String hintText;
  final IconButton? suffixIcon;
  final bool obscureText ;
  Widget? prefixIcon;
  TextInputD({Key? key,required this.tec,required this.hintText,required this.obscureText,this.suffixIcon,this.prefixIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.only(left: 25,top: 5,right: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.pink),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        controller: tec,

        obscureText: obscureText,
        decoration: InputDecoration(
          hintText:hintText,
          border: InputBorder.none,
          suffixIcon:suffixIcon,
          prefixIcon: prefixIcon
        ),
      ),
    );
  }
}