import 'package:buoi8/app/data/sqlite.dart';
import 'package:buoi8/app/model/cart.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> cart = [];
  final DatabaseHelper _helper = DatabaseHelper();
  Future<void> updateCart() async {
    cart = await _helper.getCartItems();
  }

  int get cartCount => cart.length;

  Future<void> addToCart(Cart item) async {
    await _helper.addToCart(item);
    await updateCart();
    notifyListeners();
  }

  Future<void> removeFromCart(int item) async {
    await _helper.deleteProduct(item);
    await updateCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    await _helper.clear();
    await updateCart();
    notifyListeners();
  }
}
