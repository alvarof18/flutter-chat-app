import 'dart:io';
import 'dart:ui';

import 'package:chatapp/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isTyping = false;

  List<ChatMessage> chatMessages = [
    // ChatMessage(text: 'Hola, como estas', uid: '123'),
    // ChatMessage(text: 'Bien y tu', uid: '456'),
    // ChatMessage(text: 'Me alegro', uid: '123'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 12,
              backgroundColor: Colors.blue[100],
              child: const Text(
                'TE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Alvaro Figueroa',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: chatMessages.length,
                    itemBuilder: (_, int index) {
                      return chatMessages[index];
                    })),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
              child: TextField(
                  controller: _textController,
                  onSubmitted:
                      _handleSummit, // Para enviar el texto cuando se presiona Enter
                  onChanged: (String text) {
                    setState(() {
                      if (text.trim().length > 0) {
                        _isTyping = true;
                      } else {
                        _isTyping = false;
                      }
                    });
                  },
                  focusNode: _focusNode,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Send Message',
                  ))),

          //Boton de Enviar

          Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(child: Text('Enviar'), onPressed: () {})
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            //onPressed: null,
                            onPressed: _isTyping
                                ? () =>
                                    _handleSummit(_textController.text.trim())
                                : null,
                            icon: Icon(
                              Icons.send,
                              color: Colors.blue[400],
                            )),
                      ),
                    ))
        ],
      ),
    ));
  }

  _handleSummit(String text) {
    if (text.isEmpty) return;

    print(text);
    _textController.clear();
    _focusNode.requestFocus();

    final _newMessage = ChatMessage(
      text: text,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    );
    chatMessages.insert(0, _newMessage);
    _newMessage.animationController.forward();

    setState(() {
      _isTyping = false;
    });

    @override
    void dispose() {
      for (ChatMessage message in chatMessages) {
        message.animationController.dispose();
      }
      super.dispose();
    }
  }
}
