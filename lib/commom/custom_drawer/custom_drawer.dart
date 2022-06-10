import 'package:flutter/material.dart';
import 'package:app_tcc/commom/custom_drawer/custom_drawer_header.dart';
import 'package:app_tcc/commom/custom_drawer/drawer_tile.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: Drawer(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color.fromRGBO(255, 60, 120, 161), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 143, 186, 214),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                ),
                ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CustomDrawerHeader(),
                            Divider(
                              thickness: 1.5,
                              color: Colors.black.withAlpha(180),
                            ),
                            DrawerTile(
                              iconData: Icons.home,
                              title: 'Início',
                              page: 0,
                            ),
                            DrawerTile(
                              iconData: Icons.person,
                              title: 'Contatos',
                              page: 1,
                            ),
                            DrawerTile(
                              iconData: Icons.wallet_travel,
                              title: 'Produtos',
                              page: 2,
                            ),
                            DrawerTile(
                              iconData: Icons.playlist_add_check,
                              title: 'Pedidos',
                              page: 3,
                            ),
                            DrawerTile(
                              iconData: Icons.attach_money,
                              title: 'Finanças',
                              page: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(32, 164, 0, 0),
                      child: GestureDetector(
                        onTap: () => Phoenix.rebirth(context),
                        child: Row(
                          children: [
                            Text('Sincronizar dados', style: TextStyle(fontSize: 16)),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Icon(Icons.sync),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
