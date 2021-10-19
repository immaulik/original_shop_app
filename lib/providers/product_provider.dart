import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:original_shop_app/models/http_exception.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var showOnlyFavorites = false;

  List<Product> get items {
    // if (showOnlyFavorites) {
    //   return _items.where((element) => element.isFavorite == true).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    // if (showOnlyFavorites) {
    //   return _items.where((element) => element.isFavorite == true).toList();
    // }
    return [..._items.where((element) => element.isFavorite == true).toList()];
  }

  // void showFavoritesOnly() {
  //   showOnlyFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   showOnlyFavorites = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://shop-app-eed91-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(json.encode(response.body));
      final List<Product> loadedProducts = [];
      final extraactedJson = json.decode(response.body) as Map<String, dynamic>;
      if (extraactedJson == null) {
        return 'Nothing';
      }
      extraactedJson.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'] as String,
            description: value['description'] as String,
            price: value['price'] as double,
            isFavorite: value['isFavorite'] as bool,
            imageUrl: value['imageUrl'] as String));
      });
      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://shop-app-eed91-default-rtdb.firebaseio.com/products.json';
    try {
      final value = await http.post(Uri.parse(url),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
          id: json.decode(value.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-eed91-default-rtdb.firebaseio.com/products/$id.json';
      print(url);
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('fdfd');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-eed91-default-rtdb.firebaseio.com/products/$id.json';
    final prodIndex = _items.indexWhere((element) => element.id == id);
    var product = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(prodIndex, product);
      notifyListeners();
      throw HttpException('could not delete product.');
    }
    product = null;

    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
