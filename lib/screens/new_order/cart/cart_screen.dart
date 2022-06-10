import 'package:app_tcc/models/contact_manager.dart';
import 'package:app_tcc/models/order_product_manager.dart';
import 'package:app_tcc/models/product_manager.dart';
import 'package:app_tcc/models/product_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedContact = '';
  String selectedValue = '';
  int selectedQtd = 0;
  ProductSize? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Consumer<OrderProductManager>(
                builder: (_, cartManager, __) {
                  final product =
                      context.read<ProductManager>().findProductById(selectedValue);
                  return Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Cliente',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('contacts')
                                          .where('deleted', isEqualTo: false)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Text('Carregando...');
                                        else {
                                          List<DropdownMenuItem> contacts = [];
                                          print(snapshot.data!.docs.length);
                                          for (int i = 0;
                                              i < snapshot.data!.docs.length;
                                              i++) {
                                            QueryDocumentSnapshot snap =
                                                snapshot.data!.docs[i];
                                            final contact = context
                                                .read<ContactManager>()
                                                .findContactById(snap.id);
                                            contact!.client == true
                                                ? contacts.add(DropdownMenuItem(
                                                    child: Text(contact.name.toString()),
                                                    value: snap.id,
                                                  ))
                                                : null;
                                          }
                                          return DropdownButtonFormField<dynamic>(
                                            isExpanded: true,
                                            value: (selectedContact.isEmpty)
                                                ? null
                                                : selectedContact,
                                            items: contacts,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedContact = newValue.toString();
                                                selectedValue = '';
                                                selectedSize = null;
                                                selectedQtd = 0;
                                              });
                                            },
                                            hint: Text('Defina o Cliente'),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            decoration:
                                                InputDecoration(border: InputBorder.none),
                                            validator: (client) {
                                              if (client == null)
                                                return 'Selecione um cliente';
                                              return null;
                                            },
                                            onSaved: (contact) => cartManager.contact =
                                                context
                                                    .read<ContactManager>()
                                                    .findContactById(contact.toString()),
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Produto',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('products')
                                          .where('deleted', isEqualTo: false)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Text('Carregando...');
                                        else {
                                          List<DropdownMenuItem> products = [];
                                          for (int i = 0;
                                              i < snapshot.data!.docs.length;
                                              i++) {
                                            QueryDocumentSnapshot snap =
                                                snapshot.data!.docs[i];
                                            final prod = context
                                                .read<ProductManager>()
                                                .findProductById(snap.id);
                                            products.add(DropdownMenuItem(
                                              child: Text(prod!.name.toString()),
                                              value: snap.id,
                                            ));
                                          }
                                          return DropdownButtonFormField<dynamic>(
                                            isExpanded: true,
                                            value: (selectedValue.isEmpty)
                                                ? null
                                                : selectedValue,
                                            items: products,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedValue = newValue.toString();
                                                selectedSize = null;
                                                selectedQtd = 0;
                                                cartManager.selectedProductID =
                                                    selectedValue;
                                              });
                                            },
                                            hint: Text('Escolha um Produto'),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            decoration:
                                                InputDecoration(border: InputBorder.none),
                                            validator: (product) {
                                              if (product == null)
                                                return 'Selecione um produto';
                                              return null;
                                            },
                                            onSaved: (product) => cartManager
                                                .selectedProductID = selectedValue,
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Tamanho',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child:
                                          Consumer<ProductManager>(builder: (_, ___, __) {
                                        List<DropdownMenuItem> sizes = [];
                                        final prod = context
                                            .read<ProductManager>()
                                            .findProductById(
                                                cartManager.selectedProductID);
                                        if (prod == null) {
                                          return Text('Selecione um produto');
                                        } else {
                                          for (int i = 0; i < prod.sizes!.length; i++) {
                                            final snap = prod.sizes!.asMap()[i];
                                            final snapStock = snap!.hasStock;
                                            print(snap.sizeValue);
                                            print(snapStock);
                                            sizes.add(DropdownMenuItem(
                                              child: snapStock
                                                  ? Text(snap.sizeValue.toString(),
                                                      style:
                                                          TextStyle(color: Colors.black))
                                                  : Text(
                                                      snap.sizeValue.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withAlpha(100)),
                                                    ),
                                              value: snap,
                                            ));
                                          }
                                          return DropdownButtonFormField<dynamic>(
                                            isExpanded: true,
                                            value: sizes.last.value,
                                            items: sizes,
                                            onChanged: (newValue) {
                                              final sizeAux = sizes
                                                  .firstWhere((element) =>
                                                      element.value == newValue)
                                                  .value as ProductSize;
                                              print('sa: ${sizeAux.hasStock}');
                                              sizeAux.hasStock
                                                  ? setState(() {
                                                      selectedSize = sizeAux;
                                                      print('SSIZE: ${selectedSize}');

                                                      cartManager.setSelectedSize(
                                                          product!, sizeAux);
                                                    })
                                                  : ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                      content: const Text(
                                                          'Tamanho escolhido sem estoque'),
                                                      backgroundColor: Colors.redAccent,
                                                      duration: Duration(seconds: 2),
                                                    ));
                                            },
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            decoration:
                                                InputDecoration(border: InputBorder.none),
                                            validator: (size) {
                                              if (size == null)
                                                return 'Selecione um tamanho';
                                              return null;
                                            },
                                          );
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'QTD.',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.1,
                                      child: DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        value: selectedQtd,
                                        items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                                            .map<DropdownMenuItem<int>>((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text('${value}'),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedQtd = newValue!;
                                            print('sqtd: ${selectedQtd}');
                                          });
                                        },
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        decoration:
                                            InputDecoration(border: InputBorder.none),
                                        validator: (qtd) {
                                          if (qtd == null) return 'Escolha a quantidade';
                                          if (selectedSize == null) return 'X';
                                          selectedSize!.stock! < qtd
                                              ? ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                    content: const Text(
                                                        'Quantidade não disponível'),
                                                    backgroundColor: Colors.redAccent,
                                                    duration: Duration(seconds: 2),
                                                  ))
                                                  .toString()
                                              : null;
                                        },
                                        onSaved: (qtd) =>
                                            cartManager.selectedProductQtd = selectedQtd,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  onPrimary: Colors.white,
                                  onSurface:
                                      Theme.of(context).primaryColor.withAlpha(100),
                                ),
                                onPressed: !cartManager.loading
                                    ? () async {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          context
                                              .read<OrderProductManager>()
                                              .addToOrder(product!);
                                          print('producto: ${product}');
                                          Navigator.of(context).pushNamed('/checkout');
                                        }
                                      }
                                    : null,
                                child: cartManager.loading
                                    ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      )
                                    : Text(
                                        'Adicionar item ao pedido',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/checkout');
        },
        child: Icon(Icons.shopping_cart_sharp),
      ),
    );
  }
}
