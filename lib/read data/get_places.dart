import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class GetPlace extends StatelessWidget {
  final String placedocumentId;

  GetPlace({required this.placedocumentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference places =
        FirebaseFirestore.instance.collection('places');

    return FutureBuilder<DocumentSnapshot>(
      future: places.doc(placedocumentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('$placedocumentId', style: GoogleFonts.josefinSans());
        }
        return Text("Cargando", style: GoogleFonts.josefinSans());
      }),
    );
  }
}
