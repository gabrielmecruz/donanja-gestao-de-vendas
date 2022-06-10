import 'package:app_tcc/commom/order/dialog_cancel.dart';
import 'package:app_tcc/models/order.dart';
import 'package:app_tcc/screens/order/components/order_product_tile.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.canceled ? Colors.red : primaryColor,
                  fontSize: 14),
            )
          ],
        ),
        children: [
          Column(
            children: order.items!.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          if (showControls &&
              order.status != Status.canceled &&
              order.status != Status.confirmed)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TextButton(
                    onPressed: order.status!.index == 1
                        ? () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => CancelOrderDialog(order));
                          }
                        : () {
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
                                            height: 190,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                10,
                                                40,
                                                10,
                                                10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Falha ao cancelar pedido!',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                    child: Text(
                                                      'Pedido já confirmado! Não é possível cancelar!',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
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
                                                Icons.assistant_photo,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                    child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: order.paid,
                    child: order.status!.index == 2
                        ? Text(
                            'Pago',
                            style: TextStyle(color: Colors.black45),
                          )
                        : Text(
                            'Confirmar pagamento',
                          ),
                  ),
                  order.status!.index == 2
                      ? TextButton(
                          onPressed: order.delivered,
                          child: order.status!.index == 3
                              ? Text(
                                  'Entregue',
                                  style: TextStyle(color: Colors.black45),
                                )
                              : Text(
                                  'Confirmar entrega',
                                ),
                        )
                      : SizedBox(),
                  /*FlatButton(
                    onPressed: order.advance,
                    child: const Text('Avançar'),
                  ),*/
                ],
              ),
            )
        ],
      ),
    );
  }
}
