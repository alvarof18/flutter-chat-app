import 'dart:convert';

import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/users.dart';
import 'package:chatapp/models/usuarios_response.dart';
import 'package:chatapp/services/auth_service.dart';

import 'package:http/http.dart' as http;

// Otro metodo sin mixing con ChangeNotifier
class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      var url = Uri.http(Enviroment.baseUrl, '/api/usuarios');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = UsuariosResponse.fromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
