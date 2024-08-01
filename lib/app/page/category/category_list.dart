import 'package:buoi8/app/page/category/category_add.dart';
import 'package:buoi8/app/page/category/category_data.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Danh mục sản phẩm"),
      ),
      body: Center(child: CategoryBuilder()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const CategoryAdd(),
                  fullscreenDialog: true,
                ),
              )
              .then((_) => setState(() {}));
        },
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
