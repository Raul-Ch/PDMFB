// ignore_for_file: prefer_const_constructors

//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controladores de Texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //COLOR FONDO
        //backgroundColor: Colors.grey[300],
        body: Container(
      decoration: BoxDecoration(
          //Degradado Fondo
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [
          //Colores Degradado
          Color.fromARGB(255, 42, 161, 190),
          Color.fromARGB(255, 128, 57, 221),
        ],
      )),
      child: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Icon(Icons.account_circle_outlined, size: 150),
          SizedBox(height: 20), //Espacio
          //PRIMER MENSAJE
          Text('Buen dia Viajero',
              style: GoogleFonts.carterOne(
                fontSize: 36,
              )),
          //SizedBox(height: 5),
          Text('-Bienvenido-',
              style: GoogleFonts.carterOne(
                fontSize: 25,
              )),
          SizedBox(height: 50), //Espacio

          //EMAIL TEXTFIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _emailController,
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
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadiusDirectional.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Contraseña",
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 50),

          //BOTON INICIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: signIn,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                    child: Text(
                  "Inicio Sesión",
                  style: GoogleFonts.carterOne(
                    fontSize: 20,
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
                style: GoogleFonts.carterOne(fontSize: 15),
              ),
              Text(
                "  Registrarme",
                style: GoogleFonts.carterOne(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ],
          )
        ],
      ))),
    ));
  }
}
