import 'dart:ui';

import 'package:app_tcc/models/product.dart';
import 'package:app_tcc/models/product_manager.dart';
import 'package:app_tcc/screens/edit_product/components/images_form.dart';
import 'package:app_tcc/screens/edit_product/components/sizes_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar produto' : 'Criar produto'),
          centerTitle: true,
          actions: [
            if (editing)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<ProductManager>().delete(product);
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
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name!.length < 6) return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Valor',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'R\$ ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Flexible(
                          child: TextFormField(
                            initialValue: product.price?.toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            decoration: const InputDecoration(
                              hintText: '',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[-\,\ +]'))
                            ],
                            validator: (price) {
                              if (num.tryParse(price!) == null) return 'Inválido';
                              return null;
                            },
                            onSaved: (price) => product.price = num.tryParse(price!),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Descrição',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc!.length < 10) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product),
                    const SizedBox(height: 20),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              onPrimary: Colors.white,
                              onSurface: primaryColor.withAlpha(100),
                            ),
                            onPressed: !product.loading
                                ? () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      await product.save();
                                      context.read<ProductManager>().update(product);
                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            child: product.loading
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
                    ),
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
