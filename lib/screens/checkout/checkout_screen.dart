import 'package:app_tcc/commom/price_card.dart';
import 'package:app_tcc/models/checkout_manager.dart';
import 'package:app_tcc/models/order_product_manager.dart';
import 'package:app_tcc/screens/new_order/cart/components/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<OrderProductManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Confirmar Pedido'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Enviando pedido...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      )
                    ],
                  ),
                );
              }

              return Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: checkoutManager.cartManager!.items
                          .map((cartProduct) => CartTile(cartProduct))
                          .toList(),
                    ),
                    PriceCard(
                      cartManager: checkoutManager.cartManager,
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        print(checkoutManager.cartManager!.items.isEmpty);
                        if (checkoutManager.cartManager!.items.isEmpty) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    height: 140,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        10,
                                        40,
                                        10,
                                        10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Carrinho vazio!',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blueGrey.shade700,
                                            ),
                                            child: Text(
                                              'Fechar',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -30,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.redAccent,
                                      radius: 30,
                                      child: Icon(
                                        Icons.remove_shopping_cart_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            checkoutManager.checkout(
                              onStockFail: (e) {
                                Navigator.of(context).popUntil(
                                    (route) => route.settings.name == '/new_order');
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('$e'),
                                  backgroundColor: Colors.red,
                                ));
                              },
                              onSuccess: (order) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                              },
                            );
                          }
                        }
                        ;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            onSurface: Colors.red.withAlpha(100),
                          ),
                          onPressed: () {
                            setState(() {
                              checkoutManager.cartManager!.clear();
                            });
                          },
                          child: Text('Limpar carrinho'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
