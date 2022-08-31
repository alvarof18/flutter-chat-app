import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  const ButtonBlue({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.blue,
      elevation: 2,
      shape: const StadiumBorder(),
      highlightElevation: 5,
      child: Container(
          width: double.infinity,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ))),
    );
  }
}
