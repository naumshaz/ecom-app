import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsService {
  static const productsUrl = 'https://fakestoreapi.com/products';

  Future<Map<String, dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'error', 'statuscode': response.statusCode};
      }
    } catch (e) {
      return {'message': e.toString()};
    }
  }
}
