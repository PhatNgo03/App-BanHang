import 'dart:io';

import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/model/product.dart';
import 'package:buoi8/app/page/product/product_add.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductBuilder extends StatefulWidget {
  const ProductBuilder({Key? key}) : super(key: key);

  @override
  State<ProductBuilder> createState() => _ProductBuilderState();
}

class _ProductBuilderState extends State<ProductBuilder> {
  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  Future<void> _deleteProduct(ProductModel pro) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await APIRepository().removeProduct(
      pro.id,
      pref.getString('accountID').toString(),
      pref.getString('token').toString(),
    );
    setState(() {});
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, ProductModel pro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProduct(pro);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemProduct = snapshot.data![index];
              return _buildProduct(itemProduct, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              child: Text(
                pro.id.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
              ),
              child: pro.imageUrl.startsWith('https')
                  ? Image.network(
                      pro.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )
                  : Image.file(
                      File(pro.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    NumberFormat('#,##0').format(pro.price),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text('Description: ' + pro.description),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                showDeleteConfirmationDialog(context, pro);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (_) => ProductAdd(
                      isUpdate: true,
                      productModel: pro,
                    ),
                    fullscreenDialog: true,
                  ),
                )
                    .then((result) {
                  if (result == true) {
                    setState(() {});
                  }
                });
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
