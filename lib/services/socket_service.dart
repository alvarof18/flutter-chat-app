import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { onLine, offLine, Conecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  void connect() async {
    final token = await AuthService.getToken();

    _socket = IO.io(
        Enviroment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'x-token': token})
            .build());

    // Conectado al Server
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.onLine;
      notifyListeners();
      //print('connect');
    });
    // Desconectado del server
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (data) {
    //   print('Nombre: ' + data['nombre']);
    //   print('Mensaje: ' + data['mensaje']);
    // });
    // // socket.on('fromServer', (_) => print(_));
  }

  void disconnet() {
    _socket.disconnect();
  }
}
