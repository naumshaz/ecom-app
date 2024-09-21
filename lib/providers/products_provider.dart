import 'package:ecomapp/services/products_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductsService _productsService = ProductsService();

  Future<List<dynamic>> getProducts() async {
    return _productsService.fetchProducts();
  }

  String _productID = '';
  String get productID => _productID;

  String _productTitle = '';
  String get productTitle => _productTitle;

  String _productPrice = '';
  String get productPrice => _productPrice;

  String _productDescription = '';
  String get productDescription => _productDescription;

  String _productCategory = '';
  String get productCategory => _productCategory;

  String _productImage = '';
  String get productImage => _productImage;

  String _productRating = '';
  String get productRating => _productRating;

  bool _productIsFav = false;
  bool get productIsFav => _productIsFav;

  Map<String, dynamic> getProductDetails() {
    return {
      'id': productID,
      'title': productTitle,
      'price': productPrice,
      'description': productDescription,
      'category': productCategory,
      'image': productImage,
      'rating': productRating,
      'isFavourite': productIsFav,
    };
  }

  void setProductDetails(
      String id,
      String title,
      String price,
      String description,
      String category,
      String image,
      String rating,
      bool isFav) {
    _productID = id;
    _productTitle = title;
    _productPrice = price;
    _productDescription = description;
    _productCategory = category;
    _productImage = image;
    _productRating = rating;
    _productIsFav = isFav;
  }
}
