// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:original_shop_app/providers/product.dart';
import 'package:original_shop_app/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screem.dart';

class UserProductItem extends StatelessWidget {
  final Product _product;
  // ignore: prefer_const_constructors_in_immutables
  UserProductItem(this._product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(_product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: _product.id);
                },
                color: Theme.of(context).primaryColor,
                icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .deleteProduct(_product.id);
                } catch (error) {
                  scaffold.showSnackBar(
                      SnackBar(content: Text('Deleting Failed!!')));
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
