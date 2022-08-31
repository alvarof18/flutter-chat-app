import 'dart:convert';

import 'package:chatapp/models/users.dart';

class LoginResponse {
  LoginResponse({
    required this.ok,
    required this.usuario,
    required this.token,
  });

  final bool ok;
  final Usuario usuario;
  final String token;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: Usuario.fromMap(json["usuario"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "usuario": usuario.toMap(),
        "token": token,
      };
}
