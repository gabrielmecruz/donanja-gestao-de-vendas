import 'package:flutter/material.dart';

class FinanceFilterDrawer extends StatefulWidget {
  late final String title;

  @override
  _FinanceFilterDrawerState createState() => _FinanceFilterDrawerState();
}

class _FinanceFilterDrawerState extends State<FinanceFilterDrawer>
    with AutomaticKeepAliveClientMixin {
  bool gain = false;
  bool loss = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: 280,
      child: Drawer(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Filtrar transações',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Container(
                            width: 116,
                            child: Text(
                              'Exibir somente entradas',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.white.withOpacity(0.5);
                              } else {
                                return Colors.white;
                              }
                            }),
                          ),
                        ),
                        Column(
                          children: [
                            Switch(
                              value: gain,
                              onChanged: (newState) {
                                setState(() {
                                  gain = !gain;
                                  loss == true ? loss = false : loss = false;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.black54,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Container(
                            width: 116,
                            child: Text(
                              'Exibir somente saídas',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.white.withOpacity(0.5);
                              } else {
                                return Colors.white;
                              }
                            }),
                          ),
                        ),
                        Column(
                          children: [
                            Switch(
                              value: loss,
                              onChanged: (newState) {
                                setState(() {
                                  loss = !loss;
                                  gain == true ? gain = false : gain = false;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 60),
                    TextButton(
                      child: Center(
                        child: Text(
                          'Limpar filtro',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          gain = false;
                          loss = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
