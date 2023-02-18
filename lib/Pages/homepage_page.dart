import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdmbd_his/Pages/places_page.dart';
import 'package:pdmbd_his/Pages/userpage_page.dart';
import 'package:pdmbd_his/read%20data/get_places.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables para FIREBASE
  final user = FirebaseAuth.instance.currentUser!;
  final title = 'Patrimonio Cultural de México';
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final _pageuid = TextEditingController();

  //El método Dispose limpia todos los objetos,
  @override
  void dispose() {
    _pageuid.dispose();
    super.dispose();
  }

//esto es parte de la estrucutra de Firebase para la carga de nuevos datos / nuevos lugares en nuestra lista y BD
  Future addplace() async {
    await FirebaseFirestore.instance
        .collection('places')
        .doc(_pageuid.text.trim())
        .set({});

    //setState(() {});
  }

  //Lugares en lista de string
  List<String> places = [];

//para cada lugar vamos a añadirlo a nuestra lista de lugares para poder hacer display del nombre del lugar en forma de listview
  Future getPlaces() async {
    final uid = user.uid;
    await FirebaseFirestore.instance
        .collection('places')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              //print(document.reference.id);
              places.add(document.reference.id);
            }));
  }

//borramos el numero de lugar en nuestra listview, como esta ordenado podemos borrarlo en base a su lugar y por ende su nombre de docto
  Future delete(index) async {
    await FirebaseFirestore.instance
        .collection("places")
        .doc(places[index])
        .delete();
    //setState(() {});
  }

//comienza el widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 33, 177, 141),
          centerTitle: true,
          title: Text(title),
          titleTextStyle: GoogleFonts.josefinSans(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF00695C),
          child: ListView(
            controller: ScrollController(),
            children: [
              DrawerHeader(
                  //Drawer para navegar de pagina principal a pagina de usuario
                  child: Center(
                child: Icon(
                  Icons.hail,
                  size: 100,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              )),
              //Primer Opcion
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                ),
                title: Text(
                  'Pagina Principal',
                  style: GoogleFonts.josefinSans(
                      color: Colors.white, fontSize: 20),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                  ;
                },
              ),
              //Segunda Opcion
              ListTile(
                leading: Icon(
                  Icons.supervised_user_circle_rounded,
                  color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                ),
                title: Text(
                  'Perfil',
                  style: GoogleFonts.josefinSans(
                      fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => userPage()));
                  ;
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            //Degradado Fondo
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            //Colores Degradado
            Color.fromARGB(111, 42, 160, 190),
            Color.fromARGB(108, 10, 196, 41),
          ],
        )),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              //Flexible(
              //fit: FlexFit.tight,
              child: FutureBuilder(
                //Se crea a partir de nuestros metodos de carga de datos de BD
                future: getPlaces(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    //Generando una listview que no ocupe espacio infinito del que se le permite con expanded pero
                    //Cargando todos los doctos y por ende nombres de lugares de nuestra BD
                    shrinkWrap: true,
                    controller: ScrollController(),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: ((context) {
                                    //Delete, se añade una accion desliazable que muestra un boton para elimiar ese lugar en esa posicion de lista de la lista y la BD
                                    delete(index);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }),
                                  backgroundColor:
                                      Color.fromARGB(192, 255, 82, 82),
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: ListTile(
                              //como se mencionaba anteriormente aqui se recurre al metodo para obtener cada lugar y ordenarlos en forma de lista con "tiles"
                              title: GetPlace(placedocumentId: places[index]),
                              tileColor: Colors.white,
                              trailing: Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlacesDetailPage(
                                            placedocumentId: places[index])));
                              },
                            ),
                          ));
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color.fromARGB(54, 0, 0, 0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      //Boton para añadir lugares
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //cuando se presiona hace un dialogo de alerta que te permite añadir el nombre del lugar
                              insetPadding: EdgeInsets.symmetric(vertical: 230),
                              //scrollable: false
                              title: Text("Añadir lugar"),
                              content: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Form(
                                    child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller:
                                          _pageuid, //controlador para rescatar el texto y asi crear un documento con le nombre ingresado, docto usado para la BD
                                      decoration: InputDecoration(
                                        labelText: "Nombre del lugar: ",
                                      ),
                                    )
                                  ],
                                )),
                              ),
                              actions: [
                                Padding(
                                  padding: EdgeInsetsDirectional.all(20.0),
                                  child: RaisedButton(
                                      child: Text("Añadir"),
                                      onPressed: () {
                                        addplace();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()));
                                      }),
                                )
                              ],
                            );
                          });
                    },
                  ),
                ),
              ]),
            ),
            SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}
