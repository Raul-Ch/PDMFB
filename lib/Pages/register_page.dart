import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pdmbd_his/model/adduserdata.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controladores utilizados para el paso de datos de textfield a la BD
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  //datos
  final _nameController = TextEditingController();
  final _lastNamePController = TextEditingController();
  final _lastNameMController = TextEditingController();
  final _ageController = TextEditingController();

//El método Dispose limpia todos los objetos,
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _nameController.dispose();
    _lastNamePController.dispose();
    _lastNameMController.dispose();
    _ageController.dispose();
    super.dispose();
  }

//REGISTRO , futuro y con funcion de sincronizar porque sera lo que nos permitira registrar a un usuario a nuestra bd y debe esperar a los controladores de los text field
  Future signUp() async {
    //Metodo para asegurar que el usuario introduzca las dos contraseñas correctamente
    if (passwordConfirmed()) {
      //crear usuario con usuario y contraseña de Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      //añadir datOs a la BD
      addUserDetails(
        _nameController.text.trim(),
        _lastNamePController.text.trim(),
        _lastNameMController.text.trim(),
        int.parse(_ageController.text
            .trim()), //Convertimos el string de textfield a int porque asi esta declarado en nuestra BD
        _emailController.text.trim(),
      );
    } else {
      showDialog(
          //Si las contraseñas no coinciden mostrara:
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Las contraseñas no coinciden"),
            );
          });
    }
  }

//Confirmar contraseña
  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

//Comienza nuestra WidgeT
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //COLOR FONDO
        //backgroundColor: Colors.grey[300],
        body: Container(
      decoration: BoxDecoration(
          //Degradado Fondo
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          //Colores Degradado
          Color.fromARGB(108, 10, 196, 41),
          Color.fromARGB(111, 42, 160, 190),
          //    Color.fromARGB(138, 26, 165, 26),
          //     Color.fromARGB(171, 73, 170, 114),
        ],
      )),
      child: Center(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          /*Icon(
            Icons.account_circle_outlined,
            size: 100,
            /*color: Colors.cyan,*/
          ), */
          SizedBox(height: 10), //Espacio
          //PRIMER MENSAJE
          Text('¿Eres un nuevo Viajero?',
              style: GoogleFonts.josefinSans(
                  fontSize: 25, fontWeight: FontWeight.bold)),
          //SizedBox(height: 5),
          Text('-No te preocupes, Registrate debajo-',
              style: GoogleFonts.josefinSans(
                fontSize: 20,
              )),
          SizedBox(height: 20), //Espacio

          //Nombre TEXTFIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  //recogemos el valor ingresado en el textfield en nuestro controlador previamente delclarado
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nombre",
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          //Apellido TEXTFIELD igualmente recoge el valor a nuestro controlador que pasara los datos a nuestra BD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _lastNamePController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Apellido Paterno",
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          //ApellidoM TEXTFIELD igualmente recoge el valor a nuestro controlador que pasara los datos a nuestra BD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _lastNameMController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Apellido Materno",
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          //Edad TEXTFIELD igualmente recoge el valor a nuestro controlador que pasara los datos a nuestra BD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Edad",
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          //EMAIL TEXTFIELD igualmente recoge el valor a nuestro controlador que pasara los datos a nuestra BD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(5),
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

          //Contraseña TEXTFIELD igualmente recoge el valor a nuestro controlador que pasara los datos a nuestra BD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(5),
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
          SizedBox(height: 20),

          //Contraseña confirmar txtfield igualmente recoge el valor a nuestro controlador que pasara los datos a nuestra BD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black54, width: 2),
                borderRadius: BorderRadiusDirectional.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _confirmpasswordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Confirmar Contraseña",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          //BOTON INICIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130.0),
            child: GestureDetector(
              //Si presiona el boton comenzara el proceso para registrar al usuario
              onTap: signUp,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF00695C),
                  //color: Color.fromARGB(255, 18, 134, 67),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                    child: Text(
                  "Registrarme",
                  style: GoogleFonts.josefinSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(230, 230, 252, 235),
                  ),
                )),
              ),
            ),
          ),

          SizedBox(height: 10),

          //Volver, si ya tiene cuenta aqui podra presionar iniciar sesión para regresar a la pagina de Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                "Ya tengo un usuario",
                style: GoogleFonts.josefinSans(fontSize: 15),
              ),
              GestureDetector(
                onTap: widget.showLoginPage,
                child: Text(
                  "  Iniciar Sesión",
                  style: GoogleFonts.josefinSans(
                    //color: Color.fromARGB(255, 18, 134, 67),
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
