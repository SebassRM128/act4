import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final List<Map<String, String>> products;

  const Details({Key? key, required this.products}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final GlobalKey<AnimatedListState> _listKey;
  late List<Map<String, String>> _localProducts;

  @override
  void initState() {
    super.initState();
    _localProducts = List<Map<String, String>>.from(widget.products);
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

  Widget _buildRemovedItem(Map<String, String> product, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1.0, 0.0),
        ).animate(animation),
        child: ListTile(
          leading: const Icon(Icons.pets, color: Colors.grey),
          title: Text(product["name"] ?? ""),
          subtitle: Text(product["description"] ?? ""),
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
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          title: const Text("Tabla Jaulas"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, _localProducts),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: AnimatedList(
          key: _listKey,
          initialItemCount: _localProducts.length,
          padding: const EdgeInsets.all(4.0),
          itemBuilder: (context, index, animation) {
            final product = _localProducts[index];
            return SizeTransition(
              sizeFactor: animation,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, color: Colors.grey.shade300),
                ),
                leading: const Icon(Icons.grid_on, color: Colors.blueAccent),
                title: Text(
                  product["name"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                subtitle: Text(product["description"] ?? ""),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  onPressed: () => _removeProduct(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}