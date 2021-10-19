import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:original_shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.price,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> orderItem = [];
  List<OrderItem> get orders {
    return [...orderItem];
  }

  Future<void> orderNow(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-eed91-default-rtdb.firebaseio.com/order.json';
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'date-time': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'price': e.price,
                    'title': e.title,
                    'qty': e.qty,
                  })
              .toList(),
        }));
    orderItem.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            price: total,
            products: cartProducts,
            dateTime: DateTime.now()));

    notifyListeners();
  }
}
