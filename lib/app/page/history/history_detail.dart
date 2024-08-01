import 'dart:io';

import 'package:buoi8/app/model/bill.dart';
import 'package:flutter/material.dart';

class HistoryDetail extends StatelessWidget {
  final List<BillDetailModel> bill;

  const HistoryDetail({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
      ),
      body: ListView.builder(
        itemCount: bill.length,
        itemBuilder: (context, index) {
          var data = bill[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sản phẩm: ${data.productName}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: data.imageUrl.startsWith('https')
                        ? Image.network(
                            data.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : Image.file(
                            File(data.imageUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Giá: ${data.price} đ',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Số lượng: ${data.count}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tổng cộng: ${data.total} đ',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
