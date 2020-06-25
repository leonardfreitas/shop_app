import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener((_updateImage));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
    return (startWithHttp || startWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImage);
    _imageFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    bool is_valid = _form.currentState.validate();
    if (!is_valid) {
      return;
    }

    _form.currentState.save();
    final newProduct = Product(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await products.addProduct(newProduct);
      } else {
        await products.updateProduct(newProduct);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro inesperado!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Formulário de produto'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              },
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _formData['title'],
                        decoration: InputDecoration(labelText: 'Título'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) => _formData['title'] = value,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Informe um valor válido';
                          }

                          if (value.trim().length < 3) {
                            return 'Informe um título com no mínimo 3 letras';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price'].toString(),
                        decoration: InputDecoration(labelText: 'Preço'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onSaved: (value) =>
                            _formData['price'] = double.parse(value),
                        validator: (value) {
                          bool isEmpty = value.trim().isEmpty;
                          var newPrice = double.tryParse(value);
                          bool isInvalid = newPrice == null || newPrice <= 0;
                          if (isEmpty || isInvalid) {
                            return 'Informe um preço válido';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description'],
                        decoration: InputDecoration(labelText: 'Descrição'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_imageFocusNode);
                        },
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) => _formData['description'] = value,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Url da imagem',
                              ),
                              focusNode: _imageFocusNode,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) => _formData['imageUrl'] = value,
                              validator: (value) {
                                bool isEmpty = value.trim().isEmpty;
                                bool isInvalid = !isValidImageUrl(value);
                                if (isEmpty || isInvalid) {
                                  return 'Imagem invália';
                                }

                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageController.text.isEmpty
                                ? Text('Informa a URL')
                                : Image.network(
                                    _imageController.text,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
