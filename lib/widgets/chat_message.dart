import 'dart:ui';

import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key,
      required this.text,
      required this.uid,
      required this.animationController})
      : super(key: key);

  final String text;
  final String uid;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      child: Container(
        child:
            (uid == authService.usuario.uid) ? _myMessage() : _otherMessage(),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: const Color(0xff4D9EF6),
              borderRadius: BorderRadius.circular(20)),
          child: Text(text),
        ));
  }

  Widget _otherMessage() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: const Color(0xffE4E5E8),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ));
  }
}
