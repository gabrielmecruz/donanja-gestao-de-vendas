import 'package:app_tcc/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen(this.contact);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    String getInitials(String contactName) => contactName.isNotEmpty
        ? contactName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
        : '';
    String contactLetter = getInitials(contact.name!);

    Future<void> openPhone() async {
      if (await canLaunch('tel:${contact.cleanPhone}')) {
        launch('tel:${contact.cleanPhone}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Esta função não está disponível neste dispositivo'),
          backgroundColor: Colors.red,
        ));
      }
    }

    return ChangeNotifierProvider.value(
      value: contact,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            contact.name!,
            style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            !contact.deleted!
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed('/edit_contact', arguments: contact);
                    },
                  )
                : Container()
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    child: Text('${contactLetter}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                        )),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      contact.name!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Telefone:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      contact.phone.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.phone),
                      color: primaryColor,
                      onPressed: openPhone,
                    ),
                  ),
                  Divider(color: Colors.black54),
                  ListTile(
                    title: Text(
                      'Endereço:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      contact.address!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      Icons.house,
                      color: primaryColor,
                    ),
                  ),
                  Divider(color: Colors.black54),
                  ListTile(
                    title: Text(
                      'Tipo de Pessoa:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      contact.juridicalPerson! == true
                          ? 'Pessoa Jurídica'
                          : 'Pessoa Física',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      Icons.assignment_ind,
                      color: primaryColor,
                    ),
                  ),
                  Divider(color: Colors.black54),
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 4),
                          child: Text(
                            'Relacionamento:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          contact.client! == true
                              ? 'Cliente'.toUpperCase()
                              : 'Fornecedor'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
