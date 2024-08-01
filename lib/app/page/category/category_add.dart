import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class CategoryAdd extends StatefulWidget {
  final bool isUpdate;
  final CategoryModel? categoryModel;
  const CategoryAdd({super.key, this.isUpdate = false, this.categoryModel});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String titleText = "";

  @override
  void initState() {
    super.initState();
    if (widget.categoryModel != null && widget.isUpdate) {
      _nameController.text = widget.categoryModel!.name;
      _imageController.text = widget.categoryModel!.imageUrl ?? '';
      _descController.text = widget.categoryModel!.desc;
    }
    titleText = widget.isUpdate
        ? "Cập nhật danh mục sản phẩm"
        : "Tạo mới danh mục sản phẩm";
  }

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;

    if (name.isEmpty) {
      _showErrorDialog('Vui lòng nhập tên danh mục.');
      return;
    }

    var pref = await SharedPreferences.getInstance();

    print(
        "Sending data: Name: $name, Description: $description, Image: $image");

    try {
      var response = await APIRepository().addCategory(
          CategoryModel(id: 0, name: name, imageUrl: image, desc: description),
          pref.getString('accountID').toString(),
          pref.getString('token').toString());

      print("Response from server: ${response.toString()}");

      setState(() {});
      Navigator.pop(context);
    } catch (e) {
      if (e is DioException) {
        final response = e.response;
        if (response != null && response.statusCode == 400) {
          _showErrorDialog('Bad request: ${response.data}');
        } else {
          _showErrorDialog('Failed to add category: ${e.message}');
        }
        // Log chi tiết lỗi
        print("DioException caught: ${e.toString()}");
      } else {
        _showErrorDialog('An unexpected error occurred: ${e.toString()}');
      }
      // Log lỗi không phải từ Dio
      print("Non-Dio exception caught: ${e.toString()}");
    }
  }

  Future<void> _onUpdate(int id) async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;

    if (name.isEmpty || description.isEmpty || image.isEmpty) {
      _showErrorDialog('All fields are required.');
      return;
    }

    var pref = await SharedPreferences.getInstance();
    try {
      await APIRepository().updateCategory(
          id,
          CategoryModel(
              id: widget.categoryModel!.id,
              name: name,
              imageUrl: image,
              desc: description),
          pref.getString('accountID').toString(),
          pref.getString('token').toString());
      Navigator.pop(context);
    } catch (e) {
      if (e is DioException) {
        final response = e.response;
        if (response != null && response.statusCode == 400) {
          _showErrorDialog('Bad request: ${response.data}');
        } else {
          _showErrorDialog('Failed to update category: ${e.message}');
        }
      } else {
        _showErrorDialog('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  // Hiển thị thông báo lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(titleText),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên danh mục',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập đường dẫn URL',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập mô tả',
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 50.0,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey, width: 2),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {
                  widget.isUpdate
                      ? _onUpdate(widget.categoryModel!.id)
                      : _onSave();
                },
                child: const Text(
                  'Lưu',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
