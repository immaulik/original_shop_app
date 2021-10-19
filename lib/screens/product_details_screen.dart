import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class ProductDetailsScreen extends StatelessWidget {
  // Product _product;

  // ProductDetailsScreen(this._product);

  static const routeName = 'product-details';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    final loadeProduct =
        Provider.of<ProductProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadeProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadeProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadeProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                loadeProduct.description,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ],
        ),
      ),
    );
  }
}
