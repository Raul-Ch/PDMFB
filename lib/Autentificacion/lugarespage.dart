import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdmbd_his/Pages/login_page.dart';
import '../Pages/homepage_page.dart';
import '../Pages/login_page.dart';
import 'auth_page.dart';
import '../Pages/userpage_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Este metodo lo que nos dira es que de principio se llama a Home page si se tiene el dato del usuario o la autentificacion o por asi decirlo una sesión activa, de lo contrario nos enviara
    //a la pagina de autentificacion / de login o de registro para crear esta atentificacion que nos permitira entrar a la pagina inicio de la app
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
