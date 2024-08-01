import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/model/bill.dart';
import 'package:buoi8/app/page/history/history_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<BillModel>> billsFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo biến lưu trữ danh sách hóa đơn khi khởi tạo widget
    billsFuture = _getBills();
  }

  Future<List<BillModel>> _getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository()
        .getHistory(prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BillModel>>(
      future: _getBills(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Không có hóa đơn nào."));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemBill = snapshot.data![index];
              return _billWidget(itemBill, context);
            },
          ),
        );
      },
    );
  }

  Widget _billWidget(BillModel bill, BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = await APIRepository()
            .getHistoryDetail(bill.id, prefs.getString('token').toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryDetail(bill: temp)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.fullName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Tổng tiền: ' +
                              NumberFormat('#,##0').format(bill.total) +
                              ' VND',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Ngày tạo: ' + bill.dateCreated,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, bill);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Chi tiết hóa đơn:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, BillModel bill) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc muốn xóa hóa đơn này?"),
          actions: [
            TextButton(
              child: const Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Xóa"),
              onPressed: () {
                Navigator.of(context).pop();
                print("debug ${bill.id}");
                _performDeleteBill(bill.id);
              },
            ),
          ],
        );
      },
    );
  }

  //Delete bill
  Future<void> _performDeleteBill(String billId) async {
    print("Deleting bill with id: $billId");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool success = await APIRepository().deleteBill(
      billId,
      prefs.getString('token').toString(),
    );

    if (success) {
      print("success");
      setState(() {
        billsFuture = _getBills();
      });
    } else {
      print("fail");
    }
  }
}
