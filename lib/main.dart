import 'package:flutter/material.dart';
import 'package:pdmbd_his/Pages/login_page.dart';
import 'package:pdmbd_his/Autentificacion/lugarespage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//Librerias a utilizar
//import 'login.dart';

//Main de nuestro poryecto
void main() async {
  //Lo que se usara durante todo el proyecto que es la conexion de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    //Nuestro metodo a llamar sera MAINPAGE que esta en nuestra seccion de autentificacion
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //Desacivaremos el baner de Debug que nos aparece en las instancias de Flutter de prueba
      home: MainPage(),
    );
  }
}
