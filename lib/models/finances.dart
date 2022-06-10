/*
final String movimentacaoTABLE = "movimentacaoTABLE";
final String idColumn = "idColumn";
final String dataColumn = "dataColumn";
final String valorColumn = "valorColumn";
final String tipoColumn = "tipoColumn";
final String descricaoColumn = "descricaoColumn";

class Finances {
static final Finances _instance = Finances.internal();

  factory Finances() => _instance;

  Finances.internal();

  //Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "movimentacao.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $movimentacaoTABLE(" +
          "$idColumn INTEGER PRIMARY KEY," +
          "$valorColumn FLOAT," +
          "$dataColumn TEXT," +
          "$tipoColumn TEXT," +
          "$descricaoColumn TEXT)");
    });
  }

  Future<Movimentacoes> saveMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada save");
    Database dbMovimentacoes = await db;
    movimentacoes.id =
        await dbMovimentacoes.insert(movimentacaoTABLE, movimentacoes.toMap());
    return movimentacoes;
  }

  Future<Movimentacoes> getMovimentacoes(int id) async {
    Database dbMovimentacoes = await db;
    List<Map> maps = await dbMovimentacoes.query(movimentacaoTABLE,
        columns: [idColumn, valorColumn, dataColumn, tipoColumn, descricaoColumn],
        where: "$idColumn =?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Movimentacoes.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteMovimentacao(Movimentacoes movimentacoes) async {
    Database dbMovimentacoes = await db;
    return await dbMovimentacoes
        .delete(movimentacaoTABLE, where: "$idColumn =?", whereArgs: [movimentacoes.id]);
  }

  Future<int> updateMovimentacao(Movimentacoes movimentacoes) async {
    print("chamada update");
    print(movimentacoes.toString());
    Database dbMovimentacoes = await db;
    return await dbMovimentacoes.update(movimentacaoTABLE, movimentacoes.toMap(),
        where: "$idColumn =?", whereArgs: [movimentacoes.id]);
  }

  Future<List> getAllMovimentacoes() async {
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes.rawQuery("SELECT * FROM $movimentacaoTABLE");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorMes(String data) async {
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes
        .rawQuery("SELECT * FROM $movimentacaoTABLE WHERE $dataColumn LIKE '%$data%'");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<List> getAllMovimentacoesPorTipo(String tipo) async {
    Database dbMovimentacoes = await db;
    List listMap = await dbMovimentacoes
        .rawQuery("SELECT * FROM $movimentacaoTABLE WHERE $tipoColumn ='$tipo' ");
    List<Movimentacoes> listMovimentacoes = List();

    for (Map m in listMap) {
      listMovimentacoes.add(Movimentacoes.fromMap(m));
    }
    return listMovimentacoes;
  }

  Future<int> getNumber() async {
    Database dbMovimentacoes = await db;
    return Sqflite.firstIntValue(
        await dbMovimentacoes.rawQuery("SELECT COUNT(*) FROM $movimentacaoTABLE"));
  }

  Future close() async {
    Database dbMovimentacoes = await db;
    dbMovimentacoes.close();
  }
}

class Movimentacoes {
  int? id;
  String? data;
  double? valor;
  String? tipo;
  String? descricao;

  Movimentacoes();

  Movimentacoes.fromMap(Map map) {
    id = map[idColumn];
    valor = map[valorColumn];
    data = map[dataColumn];
    tipo = map[tipoColumn];
    descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      valorColumn: valor,
      dataColumn: data,
      tipoColumn: tipo,
      descricaoColumn: descricao,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }


}
*/
import 'package:app_tcc/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Transactions extends ChangeNotifier {
  String? id;
  num? value;
  bool? type;
  String? desc;
  Timestamp? date;

  Transactions();

  Transactions.fromOrder(Order order) {
    value = order.price;
    type = true;
    desc = 'Pedido ${order.orderId}';
    date = order.date;
  }

  Transactions.fromDocument(DocumentSnapshot document) {
    id = document.id;
    value = document['value'] as num;
    type = document['gain'] as bool;
    desc = document['description'] as String;
    date = document['date'] as Timestamp;
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get financeRef => firestore.collection('finances').doc(id);

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'value': value,
      'gain': type,
      'description': desc,
      'date': Timestamp.now(),
    };

    //financeRef.set(data);

    if (id == null) {
      final doc = await firestore.collection('finances').add(data);
      id = doc.id;
    } else {
      await financeRef.update(data);
    }

    loading = false;
  }

  void delete(Transactions transaction) {
    firestore.collection('finances').doc(transaction.id).delete();
  }

  num validValue(Order order) {
    try {
      if (order.status!.index < 2) return order.price!;
      return 0;
    } catch (e) {
      return 0;
    }
  }

  String toString() {
    return "Transactions(id: $id, value: $value, date: $date, type: $type, desc: $desc )";
  }
}
