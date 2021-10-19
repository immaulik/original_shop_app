import 'package:flutter/foundation.dart';
import 'package:original_shop_app/providers/cart.dart';

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

  void orderNow(List<CartItem> cartProducts, double total) {
    orderItem.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            price: total,
            products: cartProducts,
            dateTime: DateTime.now()));

    notifyListeners();
  }
}
