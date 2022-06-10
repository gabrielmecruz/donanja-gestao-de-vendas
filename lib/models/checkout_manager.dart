import 'package:app_tcc/models/finances.dart';
import 'package:app_tcc/models/order.dart';
import 'package:app_tcc/models/order_product_manager.dart';
import 'package:app_tcc/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckoutManager extends ChangeNotifier {
  OrderProductManager? cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(OrderProductManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout({Function? onStockFail, Function? onSuccess}) async {
    loading = true;

    final orderId = await _getOrderId();

    try {
      await _decrementStock();
    } catch (e) {
      cartManager!.clear();
      onStockFail!(e);
      loading = false;
      return;
    }

    final order = Order.fromOrderProductManager(cartManager!);
    order.orderId = orderId.toString();

    final transaction = Transactions.fromOrder(order);
    //transaction.value = order.price;
    transaction.date = order.date;
    transaction.desc = 'Pedido ${order.formattedId}';

    await order.save();

    cartManager!.clear();

    onSuccess!(order);

    await transaction.save();

    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/orderCounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock() {
    // 1. Ler todos os estoques 3xM
    // 2. Decremento localmente os estoques 2xM
    // 3. Salvar os estoques no firebase 2xM

    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager!.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product = productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc = await tx.get(firestore.doc('products/${cartProduct.productId}'));
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size.toString());
        if (size!.stock! - cartProduct.quantity! < 0) {
          productsWithoutStock.add(product);
        } else {
          print('quant: ${cartProduct.quantity}');
          size.stock = size.stock! - cartProduct.quantity!.toInt();
          print('teste');
          print('sizest2: ${size.stock}');
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        String? string;
        for (final product in productsWithoutStock) {
          string = product.name!;
        }
        return Future.error(
            '${string} ${productsWithoutStock.length} produtos sem estoque');
      }

      for (final product in productsToUpdate) {
        tx.update(
            firestore.doc('products/${product.id}'), {'sizes': product.exportSizeList()});
        product.exportAppStock();
      }
    });
  }
}
