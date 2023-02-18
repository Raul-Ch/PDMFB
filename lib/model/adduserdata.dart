//Datos Usuarios
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Modelo  usado al moimento del registro para añadir nuevos usuarios
//modelo en forma de los campos a usar en la Bd y en abse a los datos pasados de los controladores a las variables de este modelo
addUserDetails(String nombre, String apellidoP, String apellidoM, int edad,
    String email) async {
  final user = FirebaseAuth.instance.currentUser!;
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'Nombre': nombre,
    'Apellido Paterno': apellidoP,
    'Apellido Materno': apellidoM,
    'Edad': edad,
    'Email': email,
  });
}
