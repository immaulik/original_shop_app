// ignore_for_file: use_key_in_widget_constructors, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:original_shop_app/providers/product_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/productgrid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FiltersOptions { Favorites, All, Cart }

class ProductOverViewScreen extends StatefulWidget {
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showOnlFavorite = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MyShop'),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  if (value == FiltersOptions.Favorites) {
                    _showOnlFavorite = true;
                  } else {
                    _showOnlFavorite = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                // ignore: prefer_const_constructors
                PopupMenuItem(
                  child: const Text('Only Favorite'),
                  value: FiltersOptions.Favorites,
                ),
                const PopupMenuItem(
                  child: Text('Show All'),
                  value: FiltersOptions.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, value, ch) => Badge(
                child: ch,
                value: value.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(_showOnlFavorite));
  }
}
