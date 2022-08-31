import 'dart:convert';

import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/loginResponse.dart';
import 'package:chatapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;

  // Create storage
  final _storage = FlutterSecureStorage();

  bool _autenticando = false;
  bool get autenticando => _autenticando;

  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  //Getters del token de forma statica
  static Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

//Login
  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};
    var url = Uri.http(Enviroment.baseUrl, '/api/login');
    final resp = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

//Register
  Future register(String email, String password, String nombre) async {
    autenticando = true;
    final data = {'email': email, 'password': password, 'nombre': nombre};
    var url = Uri.http(Enviroment.baseUrl, '/api/login/new');
    final resp = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      final bodyRes = jsonDecode(resp.body);
      return bodyRes['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    if (token != null && token.isNotEmpty) {
      var url = Uri.http(Enviroment.baseUrl, '/api/login/renew');
      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token});

      print(resp.body);

      if (resp.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(resp.body);
        usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
        return true;
      }
    }
    logout();
    return false;
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }
}
