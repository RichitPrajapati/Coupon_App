import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:shopping_app/Modals/Products.dart';

class ProductApiHelper {
  ProductApiHelper._();
  static final ProductApiHelper productApiHelper = ProductApiHelper._();

  String api = "https://dummyjson.com/products";

  Future<List<Product>?> getProducts() async {
    http.Response response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      Map decodeData = jsonDecode(response.body);

      List data = decodeData["products"];

      List<Product> products =
      data.map((e) => Product.fromAPI(data: e)).toList();

      return products;
    }
    return null;
  }
}
