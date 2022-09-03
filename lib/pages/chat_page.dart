import 'dart:io';

import 'package:chatapp/models/mensaje_response.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/chat_service.dart';
import 'package:chatapp/services/socket_service.dart';
import 'package:chatapp/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((e) => ChatMessage(
        text: e.mensaje!,
        uid: e.de!,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      chatMessages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
        text: payload['mensaje'],
        uid: payload['de'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200)));

    setState(() {
      chatMessages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

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
              child: Text(
                usuarioPara.nombre.substring(0, 2).toUpperCase(),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
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
            const Divider(
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

    _textController.clear();
    _focusNode.requestFocus();

    final _newMessage = ChatMessage(
      text: text,
      uid: authService.usuario.uid,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    );
    chatMessages.insert(0, _newMessage);
    _newMessage.animationController.forward();

    setState(() {
      _isTyping = false;
    });

    socketService.socket.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': text
    });

    @override
    void dispose() {
      for (ChatMessage message in chatMessages) {
        message.animationController.dispose();
      }
      socketService.socket.off('mensaje-personal');
      super.dispose();
    }
  }
}
