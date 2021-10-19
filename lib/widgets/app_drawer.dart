import 'package:flutter/material.dart';
import '../screens/user_products_screen.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friends! '),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
            ),
            title: Text('shop'),
            onTap: () => Navigator.of(context).pushNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text('Orders'),
            onTap: () => Navigator.of(context).pushNamed(OrderScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () =>
                Navigator.of(context).pushNamed(UserProductScreen.routeName),
          ),
        ],
      ),
    );
  }
}
