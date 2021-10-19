import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});
  void toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    print(id);
    // print(value.toString());
    final url =
        'https://shop-app-eed91-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final responseCode = await http.patch(Uri.parse(url),
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (responseCode.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
      {}
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }
    notifyListeners();
  }
}
