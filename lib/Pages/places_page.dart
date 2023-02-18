import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdmbd_his/Pages/places_pages.dart';
import 'package:pdmbd_his/Pages/places_pages.dart';

class PlacesDetailPage extends StatelessWidget {
  final String placedocumentId;

  PlacesDetailPage({required this.placedocumentId});git add README.md
//Se solocita el documento para nuestra BD y que tiene el nombre de los lugares a cargar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 33, 177, 141),
          title: Text(
            //para implementarlo como titulo de app bar en nuestras paginas
            '$placedocumentId',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          titleTextStyle: GoogleFonts.josefinSans(
              fontSize: 20, fontWeight: FontWeight.bold)),
      body: Pages(
        //llamamos al metodo pages que carga todo el cuerpo de nuestras paginas asi como le pasamos el documento a utilizar para carga de BD
        placedocumentId: placedocumentId,
      ),
      //body: Center(child: Text('Lugares')),
    );
  }
}
