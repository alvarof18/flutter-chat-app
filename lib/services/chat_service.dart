import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/mensaje_response.dart';
import 'package:chatapp/models/users.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  Usuario usuarioPara =
      Usuario(nombre: 'nombre', email: 'email', online: false, uid: 'uid');

  Future<List<Mensaje>> getChat(String usuarioID) async {
    var url = Uri.http(Enviroment.baseUrl, '/api/mensajes/$usuarioID');
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final mensajeResponse = MensajesResponse.fromJson(resp.body);
    return mensajeResponse.mensaje;
  }
}
