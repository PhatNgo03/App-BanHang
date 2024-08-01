import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/model/category.dart';
import 'package:buoi8/app/page/category/category_add.dart';

class CategoryBuilder extends StatefulWidget {
  const CategoryBuilder({Key? key}) : super(key: key);

  @override
  State<CategoryBuilder> createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  Future<List<CategoryModel>> _getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getCategory(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, CategoryModel category) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xóa danh mục"),
          content: Text("Bạn có chắc chắn xóa danh mục '${category.name}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Xóa"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      bool success = await APIRepository().removeCategory(
        category.id,
        pref.getString('accountID').toString(),
        pref.getString('token').toString(),
      );
      if (success) {
        setState(() {}); // Refresh the list after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xóa thành công")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xóa thất bại")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
      future: _getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Không có danh mục nào tồn tại"));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemCat = snapshot.data![index];
              return _buildCategory(itemCat, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategory(CategoryModel category, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              alignment: Alignment.center,
              child: Text(
                category.id.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(category.desc),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _confirmDelete(context, category),
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
                        builder: (_) => CategoryAdd(
                          isUpdate: true,
                          categoryModel: category,
                        ),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
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
