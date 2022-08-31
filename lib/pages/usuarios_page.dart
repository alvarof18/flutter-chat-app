import 'package:chatapp/models/users.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(
        nombre: 'Alvaro', email: 'alvaro1@gmail.com', online: true, uid: '1'),
    Usuario(
        nombre: 'Albanys',
        email: 'albanys90@gmail.com',
        online: true,
        uid: '2'),
    Usuario(nombre: 'Pedro', email: 'pedro@gmail.com', online: false, uid: '3'),
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            authService.usuario.nombre,
            style: const TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
              onPressed: () {
                // TODO: Desconectar sockets server
                authService.logout();
                // Tambien se puede hacer
                //AuthService.deleteToken();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.black87,
              )),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        body: SmartRefresher(
          onRefresh: _getUsers,
          controller: _refreshController,
          enablePullDown: true,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue,
          ),
          child: _listViewUsers(),
        ));
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usuarios.length,
      itemBuilder: (_, int index) => _usersListTile(usuarios[index]),
      separatorBuilder: (_, int index) => const Divider(),
    );
  }

  ListTile _usersListTile(Usuario user) {
    return ListTile(
      title: Text(user.nombre),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (user.online) ? Colors.green : Colors.red),
      ),
    );
  }

  _getUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed use refreshFailed
    _refreshController.refreshCompleted();
  }
}
