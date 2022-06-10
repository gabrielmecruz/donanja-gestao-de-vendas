import 'package:app_tcc/models/contact.dart';
import 'package:app_tcc/models/contact_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditContactScreen extends StatefulWidget {
  EditContactScreen(Contact p)
      : editing = p != null,
        contact = p != null ? p.clone() : Contact();

  final Contact contact;
  final bool editing;

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedValue = '';
  int _rel = 0;
  final _person = <String>[
    'Pessoa Física',
    'Pessoa Jurídica',
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: widget.contact,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.editing ? 'Editar contato' : 'Novo contato'),
          centerTitle: true,
          actions: [
            if (widget.editing)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<ContactManager>().delete(widget.contact);
                  Navigator.of(context).pop();
                },
              )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: primaryColor,
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        initialValue: widget.contact.name,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Nome',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (name) {
                          if (name!.length < 3) return 'Nome muito curto';
                          return null;
                        },
                        onSaved: (name) => widget.contact.name = name,
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
                      subtitle: TextFormField(
                        initialValue: widget.contact.phone?.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: '(  )     -    ',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (phone) {
                          if (num.tryParse(phone!) == null &&
                              (widget.contact.phone.toString().length < 8))
                            return 'Telefone inválido';
                          return null;
                        },
                        onSaved: (phone) => widget.contact.phone = num.tryParse(phone!),
                      ),
                      leading: Icon(
                        Icons.phone,
                        color: primaryColor,
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
                      subtitle: TextFormField(
                        initialValue: widget.contact.address,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Digite o endereço',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        validator: (address) {
                          if (address!.length < 10) return 'Endereço inválido';
                          return null;
                        },
                        onSaved: (address) => widget.contact.address = address,
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
                      subtitle: SizedBox(
                        width: 40,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: (selectedValue.isEmpty) ? null : selectedValue,
                          items: _person
                              .map((el) => DropdownMenuItem(
                                    value: el,
                                    child: Text(el),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue = newValue.toString();
                            });
                            print(newValue);
                          },
                          hint: Text('Defina o tipo de Pessoa'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(border: InputBorder.none),
                          onSaved: (person) {
                            if (person == _person.last)
                              widget.contact.juridicalPerson = true;
                            else
                              widget.contact.juridicalPerson = false;
                          },
                        ),
                      ),
                      leading: Icon(
                        Icons.assignment_ind,
                        color: primaryColor,
                      ),
                    ),
                    Divider(color: Colors.black54),
                    FormField(
                      builder: (FormFieldState state) {
                        return Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 4),
                                child: Text(
                                  'Relacionamento:',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: _rel,
                                        onChanged: (vvalue) {
                                          setState(() {
                                            _rel = vvalue as int;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Cliente'.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: 2,
                                        groupValue: _rel,
                                        onChanged: (vvalue) {
                                          setState(() {
                                            _rel = vvalue as int;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Fornecedor'.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      onSaved: (value) {
                        if (_rel == 1)
                          widget.contact.client = true;
                        else if (_rel == 2) widget.contact.client = false;
                      },
                    ),
                    const SizedBox(height: 20),
                    Consumer<Contact>(
                      builder: (_, contact, __) {
                        return SizedBox(
                          height: 44,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              onPrimary: Colors.white,
                              onSurface: primaryColor.withAlpha(100),
                            ),
                            onPressed: !contact.loading
                                ? () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      await contact.save();
                                      context.read<ContactManager>().update(contact);
                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            child: contact.loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
