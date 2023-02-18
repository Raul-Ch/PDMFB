import 'package:flutter/material.dart';

import '../Pages/login_page.dart';
import '../Pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //Iniciar con login al principio
  bool showLoginPage = true;
//esta pagina muestra la pagina de login si no se tiene la autentificacion
//la atentificacion consta de tener una sesión activa o detectable por el autentificador de Firebase , en caso de ingresar una cuenta en el Login, o crear una cuenta
//automaticamente nos dejara ingresar o del registro procedermos a nuestra pagina home
  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreens);
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
