import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_list/features/products/data/models/product_model.dart';
import 'package:product_list/features/products/data/repositories/product_repository_impl.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider(this.repository);

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true; //  còn data hay không
  bool get hasMore => _hasMore;

  String? _errorMessage; //  thông báo lỗi
  String? get errorMessage => _errorMessage;

  int _skip = 0;
  final int _limit = 20;
  Timer? _debounce;
  Future<void> loadProducts({bool reset = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (reset) {
      _skip = 0;
      _products = [];
      _hasMore = true;
    }

    try {
      final newProducts = await repository.getProducts(limit: _limit, skip: _skip);

      if (newProducts.isEmpty) {
        _hasMore = false; //  hết dữ liệu
      } else {
        _products.addAll(newProducts);
        _skip += _limit;
      }
    } catch (e) {
      _errorMessage = "Không thể tải dữ liệu. Kiểm tra kết nối mạng.";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final q = query.trim().toLowerCase();

      if (q.isEmpty) {
        await loadProducts(reset: true);
        return;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        // gọi API search (vẫn dùng repository)
        final results = await repository.searchProducts(q);

        // Lọc: chỉ giữ product có title chứa query
        _products = results.where((p) {
          return p.title.toLowerCase().contains(q);
        }).toList();

        // vì search trả toàn bộ, tạm set _hasMore = false (nếu muốn paginate search cần xử lý thêm)
        _hasMore = false;

        if (_products.isEmpty) {
          _errorMessage = "Không tìm thấy sản phẩm nào cho \"$query\"";
        }
      } catch (e) {
        _errorMessage = "Tìm kiếm thất bại. Vui lòng thử lại.";
      }

      _isLoading = false;
      notifyListeners();
    });
  }
}
