import 'package:app_tcc/commom/custom_icon_button.dart';
import 'package:app_tcc/models/product_size.dart';
import 'package:flutter/material.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize({Key? key, this.size, this.onRemove}) : super(key: key);

  final ProductSize? size;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 20,
          child: TextFormField(
            initialValue: size!.sizeValue?.toString(),
            decoration: const InputDecoration(
              labelText: 'Numeração',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (sizeValue) {
              if (int.tryParse(sizeValue!) == null) return 'Inválido';
              return null;
            },
            onChanged: (sizeValue) => size!.sizeValue = int.tryParse(sizeValue),
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 20,
          child: TextFormField(
            initialValue: size!.stock?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (stock) {
              if (int.tryParse(stock!) == null) return 'Inválido';
              return null;
            },
            onChanged: (stock) => size!.stock = int.tryParse(stock),
          ),
        ),
        const SizedBox(width: 100),
        CustomIconButton(
          iconData: Icons.clear_rounded,
          color: Colors.red,
          onTap: onRemove,
        ),
      ],
    );
  }
}
