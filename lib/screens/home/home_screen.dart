import 'package:app_tcc/commom/custom_drawer/custom_drawer.dart';
import 'package:app_tcc/models/order.dart';
import 'package:app_tcc/models/order_manager.dart';
import 'package:app_tcc/models/page_manager.dart';
import 'package:app_tcc/screens/home/components/sale_chart_widget.dart';
import 'package:app_tcc/screens/home/components/transaction_chart_widget.dart';
import 'package:app_tcc/screens/home/components/order_home_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_slider/carousel_slider.dart';

typedef Widget GalleryWidgetBuilder();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                'Donanja',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Gestão de Vendas',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer2<Order, OrderManager>(builder: (_, order, orderManager, __) {
            return Column(
              children: [
                Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 60,
                  color: Colors.white,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    controller: _scrollController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 16, 0, 0),
                            child: Text(
                              'Últimos pedidos',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          //Carousel
                          orderManager.allOrders.length > 0
                              ? Container(
                                  child: CarouselSlider.builder(
                                    options: CarouselOptions(
                                      enableInfiniteScroll: false,
                                      aspectRatio: 3,
                                      enlargeCenterPage: false,
                                      viewportFraction: 1,
                                    ),
                                    itemCount: orderManager.allOrders.length,
                                    itemBuilder: (BuildContext _, index, __) {
                                      return GestureDetector(
                                        onTap: () =>
                                            context.read<PageManager>().setPage(3),
                                        child:
                                            OrderHomeTile(orderManager.allOrders[index]),
                                      );
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.fromLTRB(32, 8, 0, 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text('Não há pedidos',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.black)),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 8, 0, 0),
                            child: Text(
                              'Vendas mensais',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.white),
                              child: SaleBarChart(
                                  context.read<Order>(), orderManager.paidOrders),
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(32, 8, 0, 0),
                            child: Text(
                              'Transações mensais',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.white),
                              child: TransactionBarChart(
                                  context.read<Order>(), orderManager.paidOrders),
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => context.read<PageManager>().setPage(4),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Entrada',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withGreen(150)),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
                                        child: Text(
                                          '+ R\$${order.stackGainOrder(orderManager.paidOrders)!.toStringAsFixed(2)}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withGreen(150)),
                                        ),
                                      ),
                                      Container(
                                        width: 80,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Color(0x4D39D2C0),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${order.percentGain(orderManager.paidOrders, order.currentMonth).toStringAsFixed(1)}% ',
                                              textAlign: TextAlign.start,
                                            ),
                                            Icon(
                                              Icons.trending_up_rounded,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.read<PageManager>().setPage(4),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Saída',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 200, 0, 0)),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
                                        child: Text(
                                          '- R\$392',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 200, 0, 0)),
                                        ),
                                      ),
                                      Container(
                                        width: 80,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Color(0x9AF06A6A),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '4.5% ',
                                              textAlign: TextAlign.start,
                                            ),
                                            Icon(
                                              Icons.trending_down_rounded,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
