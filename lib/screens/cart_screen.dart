import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart),
                  ],
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return CartItems(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].qty,
                  cart.items.values.toList()[index].title);
            },
            itemCount: cart.items.length,
          )),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _loading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cart.totalAmount <= 0 || _loading)
            ? null
            : () async {
                setState(() {
                  _loading = true;
                });
                await Provider.of<Orders>(context, listen: false).orderNow(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.Clear();
                setState(() {
                  _loading = false;
                });
              },
        child: _loading
            ? CircularProgressIndicator()
            : Text(
                'ORDER NOW',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ));
  }
}
