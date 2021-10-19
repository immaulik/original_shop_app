// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:original_shop_app/providers/product.dart';
import 'package:original_shop_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  var isInit = true;
  var initValues = {
    'title': '',
    'Price': '',
    'Description': '',
    'URL': '',
  };
  var isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductProvider>(context).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'Price': _editedProduct.price.toString(),
          'Description': _editedProduct.description,
          // 'URL': _editedProduct.imageUrl,
          'URL': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // ignore: prefer_is_not_empty
      if (!_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') &&
              _imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('.png') ||
          !_imageUrlController.text.endsWith('.jpeg') ||
          !_imageUrlController.text.endsWith('.jpg')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveFrom() async {
    final isvalid = _form.currentState.validate();
    if (isvalid) {
      _form.currentState.save();

      setState(() {
        isLoading = true;
      });
      if (_editedProduct.id != null) {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        try {
          await Provider.of<ProductProvider>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('An error occurred!!'),
                    content: const Text('Something went wrong'),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Okay'))
                    ],
                  ));
        }
        // finally {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_imageUrlController.text.isEmpty
        ? "not Url"
        : _imageUrlController.text);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveFrom,
          )
        ],
        title: const Text('Edit Product'),
      ),
      body: isLoading
          // ignore: prefer_const_constructors
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues['title'],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            title: newValue,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['Price'],
                      decoration: const InputDecoration(
                        labelText: 'Prouct-Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.parse(value) == null) {
                          return 'please enter valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(newValue),
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['Description'],
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Description';
                        }
                        if (value.length < 10) {
                          return 'Should be atleast 10 characters.';
                        }
                        return null;
                      },
                      maxLines: 3,
                      focusNode: _descFocusNode,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: newValue,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URl')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: initValues['URL'],
                            decoration: const InputDecoration(
                              labelText: 'Image URL',
                            ),
                            onFieldSubmitted: (value) {
                              setState(() {});
                              _saveFrom();
                            },
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  imageUrl: newValue);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a Image-Url';
                              }

                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
