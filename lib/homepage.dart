import 'package:flutter/material.dart';
import 'package:myapp/details.dart'; // Asegúrate de que este archivo exista y contenga la pantalla que muestra la lista de reparaciones

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _problemDescriptionController = TextEditingController();
  final TextEditingController _repairCostController = TextEditingController();
  final TextEditingController _repairTimeController = TextEditingController();
  final TextEditingController _repairStatusController = TextEditingController();

  // Esta lista es la que se pasa a la pantalla Details
  final List<Map<String, dynamic>> _repairItems = [];

  @override
  void dispose() {
    _idController.dispose();
    _dateController.dispose();
    _problemDescriptionController.dispose();
    _repairCostController.dispose();
    _repairTimeController.dispose();
    _repairStatusController.dispose();
    super.dispose();
  }

  void _saveAndNavigate(BuildContext context) {
    final String id = _idController.text.trim();
    final String problemDescription = _problemDescriptionController.text.trim();
    final double? repairCost = double.tryParse(_repairCostController.text.trim());
    final String repairTime = _repairTimeController.text.trim();
    final String repairStatus = _repairStatusController.text.trim();

    DateTime? selectedDate;
    try {
      final parts = _dateController.text.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        selectedDate = DateTime(year, month, day);
      }
    } catch (e) {
      selectedDate = null;
      print('Error parsing date: $e');
    }

    if (id.isNotEmpty && selectedDate != null && problemDescription.isNotEmpty && repairCost != null && repairTime.isNotEmpty && repairStatus.isNotEmpty) {
      setState(() {
        _repairItems.add({
          "idKey": id,
          "fecha": selectedDate,
          "descripcionProblema": problemDescription,
          "costoReparacion": repairCost,
          "tiempoReparacion": repairTime,
          "estadoReparacion": repairStatus,
        });
        _idController.clear();
        _dateController.clear();
        _problemDescriptionController.clear();
        _repairCostController.clear();
        _repairTimeController.clear();
        _repairStatusController.clear();
      });

      // Navega a la pantalla Details y pasa la lista de _repairItems
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Details(products: _repairItems),
        ),
      ).then((updatedProducts) {
        if (updatedProducts != null && updatedProducts is List<Map<String, dynamic>>) {
          setState(() {
            _repairItems
              ..clear()
              ..addAll(updatedProducts);
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos obligatorios, asegúrate que el costo sea un número y la fecha sea válida.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        title: const Text(
          "Formulario Reparación de Relojes",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF191970), // Midnight Blue
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () { /* Handle search */ },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () { /* Handle settings */ },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF191970)),
              accountName: const Text("Sebastian Rojas Mata"),
              accountEmail: const Text("a.22308051281303@cbtis128.edu.mx"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Colors.red,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(
                        'https://raw.githubusercontent.com/SebassRM128/imgg/refs/heads/main/reloj.jpg'),
                  ),
                ),
              ),
            ),
            // Esta es la sección que ya tienes para "Tabla de Reparaciones"
            InkWell(
              onTap: () {
                // Al hacer tap, navega a la pantalla Details y pasa la lista actual de reparaciones
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(products: _repairItems), // Pasa la lista
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(Icons.watch, color: Color.fromARGB(255, 0, 185, 161)),
                title: Text("Tabla de Reparaciones"), // El texto "Tabla de Reparaciones" ya cumple con "Reparaciones"
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
              myController: _idController,
              fieldName: "ID",
              myIcon: Icons.numbers,
              prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
            ),
            const SizedBox(height: 15.0),
            GestureDetector(
              onTap: () async {
                DateTime initialDateForPicker;
                try {
                  final parts = _dateController.text.split('/');
                  initialDateForPicker = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                } catch (e) {
                  initialDateForPicker = DateTime.now();
                }

                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: initialDateForPicker,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF191970), // Midnight Blue
                          onPrimary: Colors.white,
                          onSurface: Colors.black87,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF191970), // Midnight Blue
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
              child: AbsorbPointer(
                child: MyTextField(
                  myController: _dateController,
                  fieldName: "Fecha (DD/MM/AAAA)",
                  myIcon: Icons.calendar_today,
                  prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _problemDescriptionController,
              fieldName: "Descripción del Problema",
              myIcon: Icons.description,
              prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _repairCostController,
              fieldName: "Costo de Reparación",
              myIcon: Icons.attach_money,
              prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _repairTimeController,
              fieldName: "Tiempo de Reparación",
              myIcon: Icons.hourglass_empty,
              prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _repairStatusController,
              fieldName: "Estado de Reparación",
              myIcon: Icons.handyman,
              prefixIconColor: const Color.fromARGB(255, 0, 62, 218),
            ),
            const SizedBox(height: 30.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: const Color(0xFF191970), // Midnight Blue
              ),
              onPressed: () => _saveAndNavigate(context),
              child: Text(
                "Agregar Reparación".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController myController;
  final String fieldName;
  final IconData myIcon;
  final Color prefixIconColor;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      keyboardType: keyboardType,
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