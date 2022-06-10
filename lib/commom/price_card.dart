import 'package:app_tcc/models/order_product_manager.dart';
import 'package:app_tcc/models/product.dart';
import 'package:app_tcc/models/product_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatefulWidget {
  const PriceCard({this.buttonText, this.onPressed, this.cartManager});

  final String? buttonText;
  final VoidCallback? onPressed;
  final OrderProductManager? cartManager; //= context.watch<OrderProductManager>();

  @override
  _PriceCardState createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  int? productQtd;
  num? productsPrice;
  num? totalPrice;
  Product? product;

  @override
  void initState() {
    productQtd = widget.cartManager!.stackOrderProductQtd();
    productsPrice = widget.cartManager!.productsPrice;
    totalPrice = widget.cartManager!.totalPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final cartManager = context.watch<OrderProductManager>();
    //final productsPrice = widget.cartManager.productsPrice;
    //final totalPrice = widget.cartManager.totalPrice;
    setState(() {
      productQtd = widget.cartManager!.stackOrderProductQtd();
      productsPrice =
          widget.cartManager!.productsPrice; //* widget.cartManager!.selectedProductQtd;
      totalPrice = widget.cartManager!.totalPrice;
      product = context
          .read<ProductManager>()
          .findProductById(widget.cartManager!.selectedProductID);
    });

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantidade de produtos'),
                      Text(productQtd != 0 ? productQtd.toString() : '0')
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'R\$ ${totalPrice != 0 ? totalPrice!.toStringAsFixed(2) : '0.00'}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                onSurface: Theme.of(context).primaryColor.withAlpha(100),
              ),
              onPressed: widget.onPressed,
              child: Text(widget.buttonText!),
            ),
          ],
        ),
      ),
    );
  }
}
