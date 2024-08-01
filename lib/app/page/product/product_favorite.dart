import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buoi8/app/model/product.dart';
import 'package:buoi8/app/data/api.dart';

class FavoriteProductsScreen extends StatefulWidget {
  @override
  _FavoriteProductsScreenState createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  List<ProductModel> favoriteProducts = [];
  List<String> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
  }

  Future<void> _loadFavoriteProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteProducts') ?? [];
    List<ProductModel> allProducts = await _getAllProducts();
    setState(() {
      favoriteProducts = allProducts
          .where((product) => favoriteIds.contains(product.id.toString()))
          .toList();
      this.favoriteIds = favoriteIds;
    });
  }

  Future<List<ProductModel>> _getAllProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  void _removeFavorite(ProductModel product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteProducts.remove(product);
      favoriteIds.remove(product.id.toString());
    });
    await prefs.setStringList('favoriteProducts', favoriteIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm yêu thích'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: favoriteProducts.isEmpty
          ? const Center(child: Text('Không có sản phẩm yêu thích nào.'))
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                        'Giá: ${NumberFormat('#,##0').format(product.price)}',
                      ),
                      leading: (product.imageUrl == null ||
                              product.imageUrl == '' ||
                              product.imageUrl == 'Null')
                          ? const SizedBox()
                          : Image.network(
                              product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              _removeFavorite(product);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }
}
