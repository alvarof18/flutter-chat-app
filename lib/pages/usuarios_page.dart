import 'package:chatapp/models/users.dart';
import 'package:flutter/material.dart';
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
    Users(name: 'Alvaro 1', email: 'alvaro1@gmail.com', online: true, uid: '1'),
    Users(
        name: 'Alvaro 2', email: 'alvarof2@gmail.com', online: true, uid: '2'),
    Users(
        name: 'Alvaro 3', email: 'alvarof3@gmail.com', online: true, uid: '3'),
    Users(
        name: 'Alvaro 4', email: 'alvarof4@gmail.com', online: false, uid: '4'),
    Users(
        name: 'Alvaro 5', email: 'alvarof5@gmail.com', online: false, uid: '5'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Mi nombre',
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
              onPressed: () {},
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

  ListTile _usersListTile(Users user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
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
