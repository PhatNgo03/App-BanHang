import 'dart:convert';
import 'package:buoi8/app/data/sharepre.dart';
import 'package:buoi8/app/model/user.dart';
import 'package:buoi8/app/page/cart/cart_screen.dart';
import 'package:buoi8/app/page/user_detail.dart';
import 'package:buoi8/app/page/history/history_screen.dart';
import 'package:buoi8/app/page/home/home_screen.dart';
import 'package:buoi8/app/page/product/product_favorite.dart';
import 'package:buoi8/app/admin/admin_management.dart';
import 'package:buoi8/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.slowMiddle,
    );
  }

  List<Widget> _pages = [
    HomeBuilder(),
    CartScreen(),
    HistoryScreen(),
    Detail(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Smart Deal",
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteProductsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 69, 148, 213),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.imageURL!.length < 5
                      ? const SizedBox()
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            user.imageURL!,
                          )),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(user.fullName!),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home_max,
              ),
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Giỏ hàng'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Lịch sử'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Sản phẩm yêu thích'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteProductsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Admin quản lý'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminManegement()));
              },
            ),
            const Divider(
              color: Colors.black,
            ),
            user.accountId == ''
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Đăng xuất'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, value, child) {
                value.updateCart();
                return Badge(
                  label: Text(value.cartCount.toString()),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Giỏ hàng',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Người dùng',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
    );
  }
}
