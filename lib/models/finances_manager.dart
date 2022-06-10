import 'package:app_tcc/models/finances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FinancesManager extends ChangeNotifier {
  FinancesManager() {
    _loadAllTransactions();
  }

  Transactions? transaction;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Transactions> _transactions = [];

  List<Transactions> get allTransactions {
    List<Transactions> output = _transactions.reversed.toList();

    return output;
  }

  String _search = '';
  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  Transactions? findContactById(String id) {
    try {
      return allTransactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> _loadAllTransactions() async {
    final QuerySnapshot snapTransactions = await firestore.collection('finances').get();

    _transactions =
        snapTransactions.docs.map((d) => Transactions.fromDocument(d)).toList();

    print(_transactions);
    notifyListeners();
    print('transações carregadas');
  }

  void update(Transactions transaction) {
    final List<Transactions> newTransactions = [];

    for (final currentTransaction in allTransactions) {
      if (currentTransaction.id != transaction.id) {
        newTransactions.add(currentTransaction);
      }
    }
    allTransactions.clear();
    allTransactions.addAll(newTransactions);
    allTransactions.add(transaction);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
