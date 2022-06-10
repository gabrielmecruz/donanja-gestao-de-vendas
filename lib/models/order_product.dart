import 'package:app_tcc/models/product.dart';
import 'package:app_tcc/models/product_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderProduct extends ChangeNotifier {
  String? id;
  String? productId;
  int? quantity;
  num? size;
  num? fixedPrice;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  OrderProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as num;

    firestore
        .doc('products/$productId')
        .get()
        .then((doc) => product = Product.fromDocument(doc));
  }

  OrderProduct({this.productId, this.quantity, this.size});

  OrderProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document['pid'] as String;
    quantity = document['quantity'] as int;
    size = document['size'] as num;

    firestore
        .doc('products/$productId')
        .get()
        .then((doc) => product = Product.fromDocument(doc));
  }

  OrderProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.sizeValue;
  }

  Product? _product;
  Product get product => _product!;
  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  ProductSize? get itemSize {
    if (product == null) return null;
    return product.findSize(size.toString());
  }

  num get unitPrice {
    if (product == null) return 0;
    return product.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity!;

  Map<String, dynamic> toOrderProductMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.sizeValue == size;
  }

  void setQtd(int qtd) {
    quantity = qtd;
    notifyListeners();
  }

  void increment() {
    quantity = quantity! + 1;
    notifyListeners();
  }

  void decrement() {
    quantity = quantity! - 1;
    notifyListeners();
  }

  bool get hasStock {
    if (product != null || product.deleted!) return false;

    final size = itemSize;

    if (size == null) return false;
    if (product.selectedSize.stock! <= 0) return false;
    return product.selectedSize.stock! >= quantity!;
  }

  @override
  String toString() {
    return 'OrderProduct{ID Prod: $productId, quantidade: $quantity, tamanho: $size}';
  }
}
