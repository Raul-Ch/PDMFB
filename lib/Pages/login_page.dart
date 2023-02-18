// ignore_for_file: prefer_const_constructors

//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'forgotpw_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controladores de Texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    //loading
    /*
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });*/
    //creamos una auterizacion de Firebase en base a los datos ingresados en nuestro Textfield
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //imoresion de errores para el usuario mal email contraseña etc
      print(e);
      //Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
    //Navigator.of(context).pop();
  }

  //El método Dispose limpia todos los objetos,
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

//comineza widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //COLOR FONDO
        //backgroundColor: Colors.grey[300],
        body: Container(
      decoration: BoxDecoration(
          //Degradado Fondo
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.centerLeft,
        colors: const [
          Color.fromARGB(111, 42, 160, 190),
          Color.fromARGB(108, 10, 196, 41),
          //Colores Degradado
          // Color.fromARGB(120, 94, 228, 149),
          //   Color.fromARGB(139, 19, 126, 19),
        ],
      )),
      child: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Icon(
            Icons.hail,
            size: 150,
            //color: Color.fromARGB(255, 33, 177, 141),
            color: Color(0xFF00695C),
            //color: Color.fromARGB(255, 18, 134, 67),
          ),
          SizedBox(height: 20), //Espacio
          //PRIMER MENSAJE
          Text('Buen dia Viajero',
              style: GoogleFonts.josefinSans(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          //SizedBox(height: 5),
          Text('-Bienvenido-',
              style: GoogleFonts.josefinSans(
                fontSize: 25,
                color: Colors.black87,
              )),
          SizedBox(height: 60), //Espacio

          //EMAIL TEXTFIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller:
                      _emailController, //controlador para uso para la autentificacion de email
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          //Contraseña TEXTFIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller:
                      _passwordController, //controlador para textfiel y la contraseña del usuario
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Contraseña",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          //cargamos la pagina de olvidar password para que el usuario la reestablezca al presionar el texto
                          return ForgotPasswordPage();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Olvide mi Contraseña",
                    style: GoogleFonts.josefinSans(
                        color: Colors.black87,
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 45),

          //BOTON INICIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130.0),
            child: GestureDetector(
              onTap: signIn,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  //color: Color.fromARGB(255, 33, 177, 141),
                  color: Color(0xFF00695C),
                  //color: Color.fromARGB(255, 18, 134, 67),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Iniciar Sesión",
                  style: GoogleFonts.josefinSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(230, 230, 252, 235),
                    //  color: Color.fromARGB(255, 255, 255, 255),
                  ),
                )),
              ),
            ),
          ),

          SizedBox(height: 10),

          //Registro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                "¿No tienes Usuario?",
                style: GoogleFonts.josefinSans(fontSize: 15),
              ),
              GestureDetector(
                //cargamos la pagina registro a la presion del texto de registarme
                onTap: widget.showRegisterPage,
                child: Text(
                  "  Registrarme",
                  style: GoogleFonts.josefinSans(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          )
        ],
      ))),
    ));
  }
}
