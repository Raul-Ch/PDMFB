import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  //El método Dispose limpia todos los objetos,
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      //Como aprte del paquete de Firebase automaticamente podemos enviar correos para reestablecer contraseñas a los correos autentificados y guardados eN fIREBASE
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  //Mensaje al usuario
                  "Se ha enviado un link a su correo para reestablecer la contraseña"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          //title: Text(""),
        ),
        body: Container(
          decoration: BoxDecoration(
              //Degradado Fondo
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              //Colores Degradado
              Color.fromARGB(255, 72, 211, 188),
              Color.fromARGB(255, 68, 146, 235),
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text("Ingresa tu correo para reestablecer tu contraseña",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.josefinSans(
                      fontSize: 20,
                    )),
              ),

              SizedBox(height: 20),

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

              MaterialButton(
                onPressed: passwordReset,
                child: Text('Enviar',
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                color: Colors.black,
              )
            ],
          ),
        ));
  }
}
