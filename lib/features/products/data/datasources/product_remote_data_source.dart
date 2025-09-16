import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductApiService {
  final String baseUrl = "https://dummyjson.com";

  /// Lấy danh sách sản phẩm có phân trang
  Future<List<Product>> fetchProducts({int limit = 20, int skip = 0}) async {
    final url = Uri.parse("$baseUrl/products?limit=$limit&skip=$skip");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> products = data["products"] ?? [];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products: ${response.statusCode}");
    }
  }

  /// Tìm kiếm sản phẩm theo tên
  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse("$baseUrl/products/search?q=$query");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> products = data["products"] ?? [];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search products: ${response.statusCode}");
    }
  }
}
