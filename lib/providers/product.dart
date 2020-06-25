import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String _baseUrl =
      'https://shop-app-flutter-5b9cc.firebaseio.com/products';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.patch(
      "$_baseUrl/${id}.json",
      body: json.encode({
        'isFavorite': isFavorite,
      }),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Ocorreu um erro ao favoritar o produto');
    }
  }
}
