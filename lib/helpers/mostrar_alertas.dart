import 'package:flutter/material.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(titulo),
            content: Text(subtitulo),
            actions: [
              MaterialButton(
                  color: Colors.blue,
                  elevation: 5,
                  onPressed: () => Navigator.pop(
                        context,
                      ),
                  child: const Text('Ok'))
            ],
          ));
}
