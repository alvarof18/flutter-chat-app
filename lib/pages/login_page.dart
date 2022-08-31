import 'package:chatapp/helpers/mostrar_alertas.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                  const Logo(title: 'Messenger'),
                  _Form(),
                  const Labels(
                    route: 'register',
                    label1: '¿No tienes cuenta?',
                    labelButton: 'Crea una ahora',
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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
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
              text: 'Log In',
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                          emailCrtl.text.trim(), passCrtl.text.trim());
                      if (loginOk) {
                        Navigator.pushReplacementNamed(context, 'users');
                      } else {
                        //Mostrar alerta
                        mostrarAlerta(context, 'Login incorrecto',
                            'Revise la informacion ingresada');
                      }
                    })
        ],
      ),
    );
  }
}
