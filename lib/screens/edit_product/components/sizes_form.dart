import 'package:app_tcc/commom/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:app_tcc/models/product.dart';
import 'package:app_tcc/models/product_size.dart';
import 'package:app_tcc/screens/edit_product/components/edit_product_size.dart';

class SizesForm extends StatefulWidget {
  const SizesForm(this.product);

  final Product product;

  @override
  _SizesFormState createState() => _SizesFormState();
}

class _SizesFormState extends State<SizesForm> {
  @override
  Widget build(BuildContext context) {
    return FormField<List<ProductSize>>(
      initialValue: widget.product.sizes!,
      validator: (sizes) {
        if (sizes!.isEmpty) return 'Insira um tamanho';
        return null;
      },
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value!.add(ProductSize());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value!.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    state.value!.remove(size);
                    state.didChange(state.value);
                  },
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
