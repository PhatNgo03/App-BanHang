import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/data/sqlite.dart';
import 'package:buoi8/app/model/cart.dart';
import 'package:buoi8/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products();
  }

  Future<num> _getTotalPrice() async {
    List<Cart> products = await _databaseHelper.products();
    num totalPrice = 0;
    for (var product in products) {
      totalPrice += product.price * product.count;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Danh sách sản phẩm",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          flex: 11,
          child: FutureBuilder<List<Cart>>(
            future: _getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Giỏ hàng của bạn đang trống"),
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
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        FutureBuilder<num>(
          future: _getTotalPrice(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Text("Đã xảy ra lỗi");
            }
            num totalPrice = snapshot.data ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng tiền:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${NumberFormat('#,##0').format(totalPrice)} đ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Hiển thị hộp thoại xác nhận
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Xác nhận thanh toán"),
                      content: const Text("Bạn có chắc chắn muốn thanh toán?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            List<Cart> cartItems =
                                await _databaseHelper.products();

                            if (cartItems.isNotEmpty) {
                              await APIRepository().addBill(cartItems,
                                  pref.getString('token').toString());
                              await _databaseHelper.clear();
                              setState(() {});

                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        const Text("Cảm ơn bạn đã mua hàng!"),
                                    content:
                                        const Text("Thanh toán thành công!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Đóng"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Thanh toán thành công!"),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Giỏ hàng của bạn đang trống."),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Đồng ý",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue, width: 1.0),
              ),
              child: const Text(
                "Thanh Toán",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Xác nhận xóa tất cả"),
                      content: const Text(
                          "Bạn có chắc chắn muốn xóa tất cả sản phẩm trong giỏ hàng?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Provider.of<CartProvider>(context, listen: false)
                                .clearCart();
                            setState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Đã xóa tất cả sản phẩm!"),
                                duration: Duration(seconds: 3),
                              ),
                            );

                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Đồng ý",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 1.0),
              ),
              child: const Text(
                "Xóa tất cả",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProduct(Cart pro, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                pro.img,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text('Số lượng: ' + pro.count.toString()),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await _databaseHelper.minus(pro);
                setState(() {});
              },
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.blue.shade800,
              ),
            ),
            Consumer<CartProvider>(builder: (context, value, child) {
              return IconButton(
                onPressed: () async {
                  await _databaseHelper.deleteProduct(pro.productID);
                  await value.removeFromCart(pro.productID);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              );
            }),
            IconButton(
              onPressed: () async {
                await _databaseHelper.addToCart(pro);
                setState(() {});
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
