import 'dart:io';

import 'package:app_tcc/models/product_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  String? id;
  String? name;
  String? description;
  num? price;
  List<String>? images;
  List<ProductSize>? sizes;

  bool? deleted = false;
  List<dynamic>? newImages;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.images,
      this.sizes,
      this.deleted = false}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get productRef => firestore.doc('products/$id');
  Reference get storageRef => storage.ref().child('products').child(id!);

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    price = document['price'] as num;
    images = List<String>.from(document['images'] as List<dynamic>);
    try {
      sizes = (document.get('sizes') as List<dynamic>)
          .map((s) => ProductSize.fromMap(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      sizes = ([]).map((s) => ProductSize.fromMap(s as Map<String, dynamic>)).toList();
    }
    deleted = ((document['deleted']) ?? false) as bool;
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes!.map((size) => size.toMap()).toList();
  }

  num? exportAppStock() {
    int stock = 0;
    for (final size in sizes!) {
      stock = size.stock!;
    }
    return stock;
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'price': price,
      'sizes': exportSizeList(),
      'deleted': false,
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await productRef.update(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages!) {
      if (images!.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final UploadTask task = storageRef.child(Uuid().v1()).putFile(newImage as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for (final image in images!) {
      if (!newImages!.contains(image)) {
        try {
          final ref = await storage.ref(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Atenção detectada ao deletar $image');
          debugPrint('${e}');
        }
      }
    }

    await productRef.update({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  ProductSize? _selectedSize;
  ProductSize get selectedSize => _selectedSize!;
  set selectedSize(ProductSize value) {
    _selectedSize = value;
    notifyListeners();
    print(selectedSize);
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes!) {
      stock += size.stock!;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0 && deleted == false;
  }

  ProductSize? findSize(String sizeValue) {
    try {
      return sizes!.firstWhere((s) => s.sizeValue.toString() == sizeValue);
    } catch (e) {
      return null;
    }
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      images: List.from(images!),
      sizes: sizes!.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

  void delete() {
    productRef.update({'deleted': true});
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, price: ${price}, images: $images, sizes: $sizes, deleted: $deleted}';
  }
}
