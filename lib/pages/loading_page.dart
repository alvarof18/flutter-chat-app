import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {}
          return Center(child: Text('Espere'));
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      //TODO: conectar con socket service
      Navigator.pushReplacementNamed(context, 'users');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
