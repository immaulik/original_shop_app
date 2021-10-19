import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.qty,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.qty;
    });
    return total;
  }

  void addItem(String pId, double price, String title) {
    if (_items.containsKey(pId)) {
      _items.update(
          pId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              qty: value.qty + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
          pId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              qty: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void Clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].qty > 1) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              qty: value.qty - 1,
              price: value.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
