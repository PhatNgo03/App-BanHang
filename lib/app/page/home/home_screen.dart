import 'package:buoi8/provider/cart_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/data/sqlite.dart';
import 'package:buoi8/app/model/cart.dart';
import 'package:buoi8/app/model/product.dart';
import 'package:buoi8/app/model/category.dart';
import 'package:buoi8/app/page/product/product_detail.dart';

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({
    super.key,
  });

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  int cartItemCount = 0;
  List<ProductModel> favoriteProducts = [];
  List<CategoryModel> categories = [];
  List<ProductModel> allProducts = [];
  int selectedCategoryId = 0;

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allProducts = await APIRepository().getProduct(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
    setState(() {});
  }

  Future<List<CategoryModel>> _getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getCategory(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  Future<void> _loadCategories() async {
    categories = await _getCategories();
    setState(() {
      categories.insert(
          0, CategoryModel(id: 0, name: 'Tất cả', imageUrl: '', desc: ''));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
    _loadCategories();
    _loadProducts();
  }

  Future<void> _loadFavoriteProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteProducts') ?? [];
    setState(() {
      favoriteProducts = allProducts
          .where((product) => favoriteIds.contains(product.id.toString()))
          .toList();
    });
  }

  // Lọc sản phẩm theo loại
  List<ProductModel> _filterProductsByCategory() {
    if (selectedCategoryId == 0) {
      return allProducts;
    } else {
      return allProducts
          .where((product) => product.categoryId == selectedCategoryId)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filterProductsByCategory();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            CarouselSlider(
              items: allProducts
                  .take(5)
                  .map((product) => _buildFittedBoxCarouselItem(product))
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Danh mục sản phẩm",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategoryId = category.id;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedCategoryId == category.id
                              ? Colors.blue
                              : Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: selectedCategoryId == category.id
                              ? Colors.blue
                              : Colors.black,
                          fontWeight: selectedCategoryId == category.id
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final itemProduct = filteredProducts[index];
                  bool isFavorite = favoriteProducts.contains(itemProduct);
                  return _buildProduct(itemProduct, context, isFavorite);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct(
      ProductModel pro, BuildContext context, bool isFavorite) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: pro),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 10),
              (pro.imageUrl == null ||
                      pro.imageUrl.isEmpty ||
                      pro.imageUrl == 'Null')
                  ? const SizedBox()
                  : Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(pro.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Image.network(pro.imageUrl),
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      pro.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${NumberFormat('#,##0').format(pro.price)} đ',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  Provider.of<CartProvider>(context, listen: false).addToCart(
                    Cart(
                      name: pro.name,
                      price: pro.price,
                      img: pro.imageUrl,
                      des: pro.description,
                      count: 1,
                      productID: pro.id,
                    ),
                  );
                },
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFittedBoxCarouselItem(ProductModel product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: FittedBox(
        fit: BoxFit.cover,
        child: product.imageUrl == null ||
                product.imageUrl.isEmpty ||
                product.imageUrl == 'Null'
            ? const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
