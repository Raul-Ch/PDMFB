import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdmbd_his/Pages/places_page.dart';
import 'package:pdmbd_his/read%20data/storage_service.dart';
import 'dart:ui' as ui;

//parte importante en nuestra carga de imagenes igualando storage a nuestro metodo creado
final Storage storage = Storage();

//Pantalla para usuarios en donde solo podran agregar comentarios y visulizar los comentarios de otros usuarios
//Primero hacemos cada widgets de los elemento y dentro del body los mandamos a llamar través de una lista
class Pages extends StatefulWidget {
  String placedocumentId;
  Pages({Key? key, required this.placedocumentId}) : super(key: key);
  @override
  State<Pages> createState() => _PagesState();
}

//desahabilitamos los textfield para que solo sean modificables cuando lo indicamos mediante valores bool
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _PagesState extends State<Pages> {
  //Controladores de texto para manejar textfields y la carga y descarga de la BD
  late String placedocumentIds = widget.placedocumentId;
  late var _situadoController = TextEditingController();
  late var _descripcionController = TextEditingController();
  //late var _likeController = TextEditingController();
//variables
  String Situado = '';
  String Descripcion = '';
  //int Like = 0;

//activar y desactivar textfield asi como mostrar o no botones
  bool _Enable = false;
  bool _Button = true;

  @override
  //El método Dispose limpia todos los objetos,
  void dispose() {
    _situadoController.dispose();
    _descripcionController.dispose();
    //_likeController.dispose();
    super.dispose();
  }

//Actualizamos los datos recogidos por nuestros controladores enviados a la BD
  Future Actualizar() async {
    //crear usuario
    await FirebaseFirestore.instance
        .collection("places")
        .doc(placedocumentIds)
        .update({
      'Situado': _situadoController.text.trim(),
      'Descripcion': _descripcionController.text.trim(),
      //'Like': int.parse(_likeController.text.trim()),
    });
  }

//El método llenado futuro y asincrono esperara llenar conforme a la BD mencionada todos nuestros textfields y/o datos usados en la pagina
  Future Llenado() async {
    FirebaseFirestore.instance
        .collection('places')
        .doc(placedocumentIds)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        var situado = data?['Situado'];
        var descripcion = data?['Descripcion'];
        //var like = data?['Like'];
        print('Document data: ${documentSnapshot.data()}');
        //Set the relevant data to variables as needed
        //print(Nombre1);
        setState(() {
          Situado = situado;
          Descripcion = descripcion;
          //  Like = like;
        });
      } else {
        print("Document does not exist on the database uid:  " +
            placedocumentIds);
      }
    });
  }

//Por eso mismo se implementa el metodo llenado desde el principio para que se cargue con estos datos la pagina
  @override
  void initState() {
    // TODO: implement initState
    Llenado();
    super.initState();
  }

  //Pages({required this.placedocumentId});
  //var storageReference = FirebaseStorage.instance.ref("placesimage/"+placedocumentId+".jpg")

//comienzo widget
  @override
  Widget build(BuildContext context) {
    print("$placedocumentIds.jpg");
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            //1/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _situadoController =
                      TextEditingController(text: Situado),
                  //controladores de texto para permitirnos cargar los datos de la BD
                  enabled: _Enable,
                  //focusNode: AlwaysDisabledFocusNode(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //hintText: Nombre,
                    /* suffixIcon: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                            },
                          )*/
                  ),
                ),
              ],
            ),
          ),
          FavoriteWidget(),
        ],
      ),
    );

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              Color(0xFF00897B), Icons.add_location, 'Ubicación'),
          _buildButtonColumn(Color(0xFF00897B), Icons.share, 'Compartir'),
          _buildButtonColumn(Color(0xFF00897B), Icons.add_comment_rounded,
              'Agregar comentario'),
        ],
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _descripcionController =
            TextEditingController(text: Descripcion),
        enabled: _Enable,
        //focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecoration(
          border: InputBorder.none,
          //hintText: Nombre,
          /* suffixIcon: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                            },
                          )*/
        ),
      ),
    );
    Widget textSection2 = Container(
        padding: const EdgeInsets.all(15),
        child: TextButton(
          child: const Text(
            'Comentarios',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF00695C),
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            //signup screen
          },
        ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            FutureBuilder(
              future: storage.downloadURL(
                  "$placedocumentIds.jpg"), //es lo utilizado para poder descargar nuestra imagen de BD a nuestro programa
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                //Todo esto es lo que nos arrojara si se encuentra o no la URL anterior
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                    width: 600,
                    height: 240,
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            ),
            /*
              Image.asset(
                'images/1.jpg',
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
              */

            titleSection,
            buttonSection,
            textSection,
            textSection2,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: MaterialButton(
                        onPressed: () {
                          ///Actualizar los botones para mostrarse y los textfields para llenarse
                          setState(() {
                            _Enable = true;
                            _Button = false;
                          });
                        },
                        color: Color.fromARGB(255, 33, 177, 141),
                        child: Text(
                          "Editar",
                          style: GoogleFonts.josefinSans(
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: MaterialButton(
                        onPressed: _Button
                            ? null
                            : () {
                                //llamamos a nuestro metodo actualizar
                                Actualizar();
                                setState(() {
                                  //regresamos los botones a lo inicial
                                  _Enable = false;
                                  _Button = true;
                                });
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    //refrescamos la pagina para mostrar cambios al instante
                                    builder: (context) => PlacesDetailPage(
                                        placedocumentId: placedocumentIds)));
                              },
                        color: Color.fromARGB(255, 33, 177, 141),
                        child: Text(
                          "Actualizar",
                          style: GoogleFonts.josefinSans(
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// Generamos que al pulsar el icono cambie, para simular un like o dislike
class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 0;
  //Creamos la función para sumar o restar los likes y se puedan visualizar
  void _toggleFavorite() {
    setState(() {
      _favoriteCount = _isFavorited ? _favoriteCount + 1 : _favoriteCount - 1;
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (_isFavorited
                ? Icon(Icons.favorite_outline_outlined)
                : Icon(Icons.favorite)),
            color: Color(0xFF00897B),
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }
}
