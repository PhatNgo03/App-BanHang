import 'dart:convert';
import 'package:buoi8/app/page/auth/forgot_password.dart';
import 'package:buoi8/app/page/auth/update_profile.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  User user = User.userEmpty();
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  Future<void>? future;
  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Card.filled(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.imageURL!),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.fullName!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.verified_user),
                          title: Text(user.idNumber ?? "null"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(user.phoneNumber!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.wc),
                          title: Text(user.gender!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.celebration),
                          title: Text(user.birthDay!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: const Text("Năm học"),
                          subtitle: Text(user.schoolYear!),
                        ),
                        ListTile(
                          leading: const Icon(Icons.school),
                          title: const Text("Khoá"),
                          subtitle: Text(user.schoolKey!),
                        ),
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword()));
                          },
                          leading: const Icon(Icons.password),
                          title: const Text("Đổi mật khẩu"),
                        ),
                        const Divider(),
                      ],
                    ),
                  )
                ],
              );
            }));
  }
}
