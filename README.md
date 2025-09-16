# product_list

A new Flutter project.

## Getting Started

lib/
 ├── core/                  
 │    ├── error/
 │    ├── network/
 │    └── usecase.dart
 │
 ├── features/
 │    └── products/
 │         ├── data/
 │         │    ├── datasources/
 │         │    │     └── product_remote_data_source.dart
 │         │    ├── models/
 │         │    │     └── product_model.dart
 │         │    └── repositories/
 │         │          └── product_repository_impl.dart
 │         │
 │         ├── domain/
 │         │    ├── entities/
 │         │    │     └── product.dart
 │         │    ├── repositories/
 │         │    │     └── product_repository.dart
 │         │    └── usecases/
 │         │          ├── get_products.dart
 │         │          └── search_products.dart
 │         │
 │         ├── presentation/
 │         │    ├── provider/      
 │         │    │     └── product_provider.dart
 │         │    └── pages/
 │         │          └── product_list_page.dart
 │         │
 │         └── products_injection.dart  
 │
 └── main.dart

## Link danh sách
https://dummyjson.com/products
Trả về JSON có danh sách sản phẩm.

## Cách chạy
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs


Kết quả

Khi không có internet → show "Không thể tải dữ liệu. Kiểm tra kết nối mạng + nút Thử lại.
Khi API lỗi → hiển thị "Tìm kiếm thất bại. Vui lòng thử lại.".
Khi list rỗng → "Không có dữ liệu".
Khi cuộn hết data → "Đã tải hết dữ liệu".