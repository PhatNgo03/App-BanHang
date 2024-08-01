import 'package:buoi8/app/page/category/category_list.dart';
import 'package:buoi8/app/page/product/product_list.dart';
import 'package:flutter/material.dart';

class AdminManegement extends StatefulWidget {
  const AdminManegement({super.key});

  @override
  State<AdminManegement> createState() => _AdminManegementState();
}

class _AdminManegementState extends State<AdminManegement> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProductList(),
    CategoryList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Quản lý'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Danh mục',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
