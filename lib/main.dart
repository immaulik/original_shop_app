import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:original_shop_app/screens/products_overview_screen.dart';
import './providers/auth.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              // ignore: deprecated_member_use
              accentColor: Colors.deepOrange,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            home: value.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            }),
      ),
    );
  }
}
