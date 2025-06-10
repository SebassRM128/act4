import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final List<Map<String, dynamic>> products; // Changed to dynamic

  const Details({Key? key, required this.products}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final GlobalKey<AnimatedListState> _listKey;
  late List<Map<String, dynamic>> _localProducts; // Changed to dynamic

  @override
  void initState() {
    super.initState();
    _localProducts = List<Map<String, dynamic>>.from(widget.products);
    _listKey = GlobalKey<AnimatedListState>();
  }

  void _removeProduct(int index) {
    final removedItem = _localProducts[index];
    _localProducts.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removedItem, animation),
      duration: const Duration(milliseconds: 400),
    );
  }

  Widget _buildRemovedItem(Map<String, dynamic> product, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1.0, 0.0),
        ).animate(animation),
        child: ListTile(
          leading: const Icon(Icons.watch, color: Colors.grey),
          title: Text(product["idKey"] ?? ""), // Display ID
          subtitle: Text("Problema: ${product["descripcionProblema"] ?? ""}, Costo: \$${product["costoReparacion"]?.toStringAsFixed(2) ?? ""}, Estado: ${product["estadoReparacion"] ?? ""}"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _localProducts);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF191970), // Midnight Blue
          centerTitle: true,
          title: const Text("Tabla de Reparaciones"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, _localProducts),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: AnimatedList(
          key: _listKey,
          initialItemCount: _localProducts.length,
          padding: const EdgeInsets.all(4.0),
          itemBuilder: (context, index, animation) {
            final product = _localProducts[index];
            return SizeTransition(
              sizeFactor: animation,
              child: Card( // Wrap in Card for better visual separation
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(width: 1.0, color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: const Icon(Icons.watch, color: Color.fromARGB(255, 0, 62, 218)), // Blue for leading icon
                  title: Text(
                    "ID: ${product["idKey"] ?? ""}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Fecha: ${product["fecha"] != null ? "${(product["fecha"] as DateTime).day}/${(product["fecha"] as DateTime).month}/${(product["fecha"] as DateTime).year}" : ""}"),
                      Text("Problema: ${product["descripcionProblema"] ?? ""}"),
                      Text("Costo: \$${product["costoReparacion"]?.toStringAsFixed(2) ?? ""}"),
                      Text("Tiempo: ${product["tiempoReparacion"] ?? ""}"),
                      Text("Estado: ${product["estadoReparacion"] ?? ""}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                    onPressed: () => _removeProduct(index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}