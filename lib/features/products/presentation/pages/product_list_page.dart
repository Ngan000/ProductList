import 'package:flutter/material.dart';
import 'package:product_list/features/products/presentation/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    provider.loadProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        provider.loadProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search products...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                provider.searchProducts(query);
              },
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final provider = context.watch<ProductProvider>();

                if (provider.isLoading && provider.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator()); // ⏳ loading lần đầu
                }

                if (provider.errorMessage != null && provider.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => provider.loadProducts(reset: true),
                          child: const Text("Thử lại"),
                        ),
                      ],
                    ),
                  );
                }
                if (provider.products.isEmpty) {
                  // search trả về rỗng (không match)
                  return const Center(child: Text("Không tìm thấy sản phẩm nào"));
                }

                return ListView.builder(
                  itemCount: provider.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == provider.products.length) {
                      if (provider.hasMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: Text("Đã tải hết dữ liệu")),
                        );
                      }
                    }

                    final product = provider.products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(product.thumbnail, fit: BoxFit.cover),
                        ),
                        title: Text(product.title),
                        subtitle: Text("\$${product.price}"),
                        trailing: const Icon(Icons.favorite_border),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
