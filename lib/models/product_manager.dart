import 'package:app_tcc/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
          allProducts.where((p) => p.name!.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredProducts;
  }

  Product? findProductById(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id && p.deleted == false);
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
        await firestore.collection('products').where('deleted', isEqualTo: false).get();

    allProducts = snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    notifyListeners();
    print('produto carregado');
  }

  void update(Product product) {
    final List<Product> newProducts = [];

    for (final currentProduct in allProducts) {
      if (currentProduct.id != product.id) {
        newProducts.add(currentProduct);
      }
    }
    allProducts.clear();
    allProducts.addAll(newProducts);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
