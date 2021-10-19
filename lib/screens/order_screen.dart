import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An Error Occurred!!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, value, child) {
                    return ListView.builder(
                        itemBuilder: (context, index) =>
                            ord.OrderItem(value.orderItem[index]),
                        itemCount: value.orderItem.length);
                  },
                );
              }
            }
          },
        ));
  }
}
