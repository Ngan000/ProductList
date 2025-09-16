import 'package:flutter/material.dart';
import 'package:product_list/features/products/data/datasources/product_remote_data_source.dart';
import 'package:product_list/features/products/data/repositories/product_repository_impl.dart';
import 'package:product_list/features/products/presentation/pages/product_list_page.dart';
import 'package:product_list/features/products/presentation/provider/product_provider.dart';
import 'package:provider/provider.dart';

void main() {
  final apiService = ProductApiService();
  final repository = ProductRepository(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductListScreen(),
    );
  }
}
