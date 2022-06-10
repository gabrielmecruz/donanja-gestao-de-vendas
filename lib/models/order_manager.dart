import 'dart:async';

import 'package:app_tcc/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderManager extends ChangeNotifier {
  OrderManager() {
    _listenToOrders();
  }

  final List<Order> _orders = [];

  List<Status> statusFilter = [Status.made];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    return output.where((o) => statusFilter.contains(o.status)).toList();
  }

  List<Order> get allOrders {
    List<Order> output = _orders.reversed.toList();

    return output;
  }

  List<Order> get paidOrders {
    List<Order> output = _orders.reversed.toList();

    return output.where((o) => o.status!.index >= 2).toList();
  }

  void _listenToOrders() {
    _subscription = firestore.collection('order').snapshots().listen((event) {
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(Order.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final modOrder = _orders.firstWhere((o) => o.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            debugPrint('Pedido deletado do banco. Deu problema sério!!!');
            break;
        }
      }
      notifyListeners();
      print('pedidos carregados');
    });
  }

  void setStatusFilter({Status? status, bool? enabled}) {
    if (enabled!) {
      statusFilter.add(status!);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  Order? orderById(String id) {
    try {
      return allOrders.firstWhere((o) => o.orderId == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
