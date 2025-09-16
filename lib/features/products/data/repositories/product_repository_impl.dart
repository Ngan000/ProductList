import 'package:product_list/features/products/data/datasources/product_remote_data_source.dart';
import 'package:product_list/features/products/data/models/product_model.dart';

class ProductRepository {
  final ProductApiService apiService;

  ProductRepository(this.apiService);

  Future<List<Product>> getProducts({int limit = 20, int skip = 0}) {
    return apiService.fetchProducts(limit: limit, skip: skip);
  }

  Future<List<Product>> searchProducts(String query) {
    return apiService.searchProducts(query);
  }
}
