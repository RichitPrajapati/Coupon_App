import 'package:flutter/material.dart';

import 'package:shopping_app/Modals/Products.dart';

class AddToCartProvider extends ChangeNotifier {
  List<Product> products = [];

  bool couponApply = false;

  get totalQuantity => products.length;

  get totalPrice {
    int price = 0;
    for (Product product in products) {
      price += product.price;
    }
    return price;
  }

  get discountPrice {
    double discount = totalPrice * 10 / 100;

    double finalPrice = totalPrice - discount;

    return finalPrice;
  }

  applyCoupon() {
    couponApply = true;
    notifyListeners();
  }

  removeCoupon() {
    couponApply = false;
    notifyListeners();
  }

  addProduct({required Product product}) {
    products.add(product);
    notifyListeners();
  }

  emptyCart() {
    products = [];
    notifyListeners();
  }

  removeProduct({required Product product}) {
    products.remove(product);
    notifyListeners();
  }
}
