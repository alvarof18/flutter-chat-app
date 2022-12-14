import 'package:chatapp/helpers/mostrar_alertas.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/socket_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(
                    title: 'Sign Up',
                  ),
                  _Form(),
                  const Labels(
                    route: 'login',
                    label1: '¿Tienes una cuenta?',
                    labelButton: 'Sign In',
                  ),
                  const Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCrtl = TextEditingController();
  final passCrtl = TextEditingController();
  final nameCrtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity_outlined,
            hintText: 'Name',
            textController: nameCrtl,
          ),
          CustomInput(
            icon: Icons.email_outlined,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCrtl,
          ),
          CustomInput(
            icon: Icons.lock_clock_outlined,
            hintText: 'Password',
            textController: passCrtl,
            isPassword: true,
          ),
          ButtonBlue(
            text: 'Sign Up',
            onPressed: authService.autenticando
                ? null
                : () async {
                    final registerOk = await authService.register(
                        emailCrtl.text.trim(),
                        passCrtl.text.trim(),
                        nameCrtl.text.trim());

                    if (registerOk == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      mostrarAlerta(
                          context, 'Error en el registro', registerOk);
                    }
                  },
          )
        ],
      ),
    );
  }
}
