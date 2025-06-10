import 'package:flutter/material.dart';
import 'package:myapp/details2.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _productController = TextEditingController();
  final _productDesController = TextEditingController();

  final List<Map<String, String>> _products = [];

  @override
  void dispose() {
    _productController.dispose();
    _productDesController.dispose();
    super.dispose();
  }

  void _saveAndNavigate(BuildContext context) {
    if (_productController.text.isNotEmpty &&
        _productDesController.text.isNotEmpty) {
      setState(() {
        _products.add({
          "name": _productController.text,
          "description": _productDesController.text,
        });
        _productController.clear();
        _productDesController.clear();
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(products: _products),
      ),
    ).then((updatedProducts) {
      if (updatedProducts != null && updatedProducts is List<Map<String, String>>) {
        setState(() {
          _products
            ..clear()
            ..addAll(updatedProducts);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        title: Text("Formulario Jaulas"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 15, 36, 94),
        actions: <Widget>[
          InkWell(
            onTap: null,
            child: new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          InkWell(
            onTap: null,
            child: new IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 21, 51, 97)),
              accountName: Text("Sebastian Rojas Mata"), // ¡Cambiado!
              accountEmail: Text("a.22308051281303@cbtis128.edu.mx"), // ¡Cambiado!
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Colors.red,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(
                      'https://raw.githubusercontent.com/SebassRM128/imgg/refs/heads/main/reloj.jpg'), // ¡Cambiado!
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(context, "/home");
                },
                leading: Icon(Icons.pets, color: const Color.fromARGB(255, 17, 25, 100)),
                title: Text("Tabla Perros"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(context, "/tablas");
                },
                leading: Icon(Icons.grid_on, color: const Color.fromARGB(255, 0, 185, 161)),
                title: Text("Tabla Jaulas"),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            MyTextField(
              myController: _productController,
              fieldName: "Nombre del campo de jaulas",
              myIcon: Icons.grid_on,
              prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              myController: _productDesController,
              fieldName: "Descripción",
              myIcon: Icons.description,
              prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
            ),
            const SizedBox(height: 20.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
              onPressed: () => _saveAndNavigate(context),
              child: Text(
                "Guardar".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 9, 108),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    required this.fieldName,
    required this.myController,
    this.myIcon = Icons.verified_user_outlined,
    this.prefixIconColor = Colors.blueAccent,
  });

  final TextEditingController myController;
  final String fieldName;
  final IconData myIcon;
  final Color prefixIconColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
        labelText: fieldName,
        prefixIcon: Icon(myIcon, color: prefixIconColor),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 93, 0, 255)),
        ),
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 53, 106)),
      ),
    );
  }
}