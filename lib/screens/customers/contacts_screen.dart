import 'package:app_tcc/commom/custom_drawer/custom_drawer.dart';
import 'package:app_tcc/models/contact_manager.dart';
import 'package:app_tcc/screens/customers/components/contact_list_tile.dart';
import 'package:app_tcc/screens/customers/components/contact_filter_drawer.dart';
import 'package:app_tcc/screens/stock/components/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      endDrawer: ContactFilterDrawer(),
      appBar: AppBar(
        title: Consumer<ContactManager>(
          builder: (_, contactManager, __) {
            if (contactManager.search.isEmpty) {
              return const Text('Contatos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(contactManager.search));
                      if (search != null) {
                        contactManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          contactManager.search,
                          textAlign: TextAlign.center,
                        )),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<ContactManager>(
            builder: (_, contactManager, __) {
              if (contactManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(contactManager.search));
                    if (search != null) {
                      contactManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    contactManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<ContactManager>(
            builder: (_, contactManager, __) {
              return IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ContactManager>(
        builder: (_, contactManager, __) {
          final filteredContacts = contactManager.filteredContactsByName;
          return SafeArea(
            child: ListView(
              controller: _scrollController,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredContacts.length,
                  itemBuilder: (_, element) {
                    return Column(
                      children: [
                        ContactListTile(filteredContacts[element]),
                        const Divider(
                          indent: 10,
                          thickness: 2,
                        )
                      ],
                    );
                  }, // optional
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/edit_contact');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
