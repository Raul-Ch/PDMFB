import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdmbd_his/model/adduserdata.dart';
import '../Autentificacion/auth_page.dart';
import 'homepage_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdmbd_his/model/adduserdata.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
//Blibliotecas

class userPage extends StatefulWidget {
  const userPage({Key? key}) : super(key: key);

  @override
  State<userPage> createState() => _userPageState();
}

//Declaracion de variables relacionadas al uso de Firebase BD
final user = FirebaseAuth.instance.currentUser!;
final uid = FirebaseAuth.instance.currentUser!.uid;

//CollectionReference users = FirebaseFirestore.instance.collection('user');
//final String documentId = UserAccountsDrawerHeader.doc(documentId).get().toString();

//Esta clase deshabilitara los TextFields utilizados
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

//Inicio de la clase del estado de UserPage -> Pagina de usuario
class _userPageState extends State<userPage> {
  //Controladores utilizados para recoger datos de TextField
  final _emailController = TextEditingController();

  //datos
  late var _nameController = TextEditingController();
  late var _lastNamePController = TextEditingController();
  late var _lastNameMController = TextEditingController();
  late var _ageController = TextEditingController();
  String _appBarTitle = '';
// Variables del codigo
  String Nombre = '';
  String ApellidoP = '';
  String ApellidoM = '';
  int Edad = 0;
  String Correo = '';

  bool _Enable = false;
  bool _Button = true;

//El método Dispose limpia todos los objetos,
  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _lastNamePController.dispose();
    _lastNameMController.dispose();
    _ageController.dispose();
    super.dispose();
  }

//Nuestro metodo futuro a utilizar encargado de actualizar la BD con los controladores de texto recogidos
//REGISTRO
  Future Actualizar() async {
    //crear usuario
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      'Nombre': _nameController.text.trim(),
      'Apellido Paterno': _lastNamePController.text.trim(),
      'Apellido Materno': _lastNameMController.text.trim(),
      'Edad': int.parse(_ageController.text.trim()),
    });
  }

//Esta función no solo nos mostrara el nombre del usuario en la APPBAR tambien sera la encargada de cargar los datos de nuestra BD actual a variables utilizadas en los TextField
  Future appBarTittle() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        var MNombre = data?['Nombre'];
        var MApellidoP = data?['Apellido Paterno'];
        var MApellidoM = data?['Apellido Materno'];
        var MEdad = data?['Edad'];
        var MCorreo = data?['Email'];
        print('Document data: ${documentSnapshot.data()}');
        //Set the relevant data to variables as needed
        //print(Nombre1);
        setState(() {
          Nombre = MNombre;
          ApellidoP = MApellidoP;
          ApellidoM = MApellidoM;
          Edad = MEdad;
          Correo = MCorreo;
          _appBarTitle = Nombre + " " + ApellidoP + " " + ApellidoM;
        });
        print(Nombre);
        print(_appBarTitle);
      } else {
        print("Document does not exist on the database uid:  " + uid);
      }
    });
  }

//Para cargar los datos antes que cualquier cosa y evitar valores nulos especificamos que el metodo anterior se correra para cargar los
//datos una vez al principio del mismo llamado de esta clase/pagina de usuarios
  @override
  void initState() {
    // TODO: implement initState
    appBarTittle();
    super.initState();
  }

//Aqui comienza nuestro Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 33, 177, 141),
          centerTitle: true,
          title: Text("Bienvenido " +
              _appBarTitle), //Con el metodo  appbartitle anterior que cuenta con esta variable la declaramos para mostrar el saludo al usuario
          titleTextStyle: GoogleFonts.josefinSans(
              fontSize: 20, color: Color.fromARGB(255, 255, 255, 255))),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF00695C),
          child: ListView(
            controller: ScrollController(),
            children: [
              //El drawer sera lo que nos permitira movernos de la pagina de usuarios a la principal
              DrawerHeader(
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
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  //Esto lo usarmeos para evitar que se "acumulen paginas" asi llamando a las siguientes y no usaremos el back del appbar
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
                    color: Colors.white,
                    fontSize: 20,
                  ),
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
        color: Colors.white,
        /*
        decoration: BoxDecoration(
            //Degradado Fondo
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            //Colores Degradado
           // Color.fromARGB(111, 42, 160, 190),
           // Color.fromARGB(108, 10, 196, 41),
          ],
        )),
        */
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Icon(
                  Icons.person,
                  size: 100,
                  //color: Color.fromARGB(255, 33, 177, 141),
                  color: Color(0xFF00695C),
                  //color: Color.fromARGB(255, 18, 134, 67),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Nombre:",
                        style: GoogleFonts.josefinSans(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                //Nombre TEXTFIELD
                //Aqui tenemos la declaracion tanto de la decoracion de la caja que contiene l textfiel como:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF00695C), width: 2),
                      borderRadius: BorderRadiusDirectional.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      //En esta parte igualamos el valor del textfield  a las variables que conseguimos por medio del metodo ya antes mecionado, y que son las cargas en nuestra BD
                      child: TextField(
                        controller: _nameController =
                            TextEditingController(text: Nombre),
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
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Apellido Paterno:",
                        style: GoogleFonts.josefinSans(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                //Apellido TEXTFIELD igualmente que el de nombre pero para el primer apellido
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF00695C), width: 2),
                      borderRadius: BorderRadiusDirectional.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _lastNamePController =
                            TextEditingController(text: ApellidoP),
                        enabled: _Enable,
                        //focusNode: AlwaysDisabledFocusNode(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // //hintText: ApellidoP,
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.edit),
                          //   onPressed: () {},
                          // )
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Apellido Materno:",
                        style: GoogleFonts.josefinSans(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                //ApellidoM TEXTFIELD  igualmente que el de nombre pero para el segundo apellido
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF00695C), width: 2),
                      borderRadius: BorderRadiusDirectional.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _lastNameMController =
                            TextEditingController(text: ApellidoM),
                        enabled: _Enable,
                        //focusNode: AlwaysDisabledFocusNode(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //hintText: ApellidoM,
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.edit),
                          //   onPressed: () {},
                          // )
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Edad:",
                        style: GoogleFonts.josefinSans(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                //Edad TEXTFIELD este cambia un poco pero sigue siendo parecido al de nombre pero:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF00695C), width: 2),
                      borderRadius: BorderRadiusDirectional.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      //Aqui manejamos INT por lo que debemos pasar nuestra edad de valor Int de Bd y de variable a una tipo String para el TextField
                      child: TextField(
                        controller: _ageController =
                            TextEditingController(text: Edad.toString()),
                        enabled: _Enable,
                        //focusNode: AlwaysDisabledFocusNode(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //hintText: Edad.toString(),
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.edit),
                          //   onPressed: () {},
                          // )
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Email:",
                        style: GoogleFonts.josefinSans(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                //EMAIL TEXTFIELD este no podra ser modificado por eso no cuenta como tal con un controlador de variable, solamente tiene uno para igual el valor de BD al textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF00695C), width: 2),
                      borderRadius: BorderRadiusDirectional.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: TextEditingController(text: Correo),
                        enabled: false,
                        //focusNode: AlwaysDisabledFocusNode(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // hintText: Correo,
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.edit),
                          //   onPressed: () {},
                          // )
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
//AQUI comienzan nuestro botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: MaterialButton(
                            onPressed: () {
                              ///activar boton, esto lo que hara sera pasar nuestro valor _Enable a true, dicho valor controla el foco de textfiel permitiendo escribir
                              ///Ademas tambien _Button permitira que nuestro boton se muestre, ya que de primera instancia el boton actualizar se muestra "invisible"
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
                                    //Corremos nuestro metodo actualizar al momento que el boton actualizar ha sido presionado
                                    Actualizar();
                                    setState(() {
                                      // Regresamos los valores bool a como estaban antes de presionar el boton editar
                                      _Enable = false;
                                      _Button = true;
                                      //appBarTittle();
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  userPage()));
                                    });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: MaterialButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.popUntil(
                                  context, ModalRoute.withName("/"));
                              //Nos regresara a la pagina de inicio y cerrara nuestra sesíón autentificada de firebase
                            },
                            color: Color.fromARGB(255, 33, 177, 141),
                            child: Text(
                              "Cerrar Sesión",
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
