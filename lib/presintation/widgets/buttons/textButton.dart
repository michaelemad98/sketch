import 'package:flutter/material.dart';


class DefaultTextButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Color txtColor;
  const DefaultTextButton({Key? key,
  required this.text,
    required this.onPressed,
    required this.txtColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: txtColor,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
