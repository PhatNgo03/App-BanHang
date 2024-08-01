import 'package:buoi8/app/config/const.dart';
import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/model/register.dart';
import 'package:buoi8/app/page/auth/forgot_password.dart';
import 'package:buoi8/mainpage.dart';
import '../register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  login() async {
    if (_formkey.currentState!.validate()) {
      String token = await APIRepository()
          .login(accountController.text, passwordController.text);

      // Lấy thông tin người dùng từ API (ví dụ)
      var user = await APIRepository().current(token);

      // Lưu token vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('accountID', user.accountId!);
      // await prefs.setString('user', jsonEncode(user.toJson()));
      saveUser(user);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Mainpage()));
      return token;
    }
  }

  @override
  void initState() {
    super.initState();
    // autoLogin();
  }

  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Mainpage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    urlLogo,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  const Text(
                    "Đăng nhập tài khoản của bạn",
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: accountController,
                          decoration: const InputDecoration(
                            labelText: "Tài khoản",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.blue,
                              ),
                            ),
                            icon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập tài khoản';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Mật khẩu",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.blue,
                              ),
                            ),
                            icon: Icon(Icons.password),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            if (value.length < 6) {
                              return 'Mật khẩu phải có ít nhất 6 kí tự';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                            shadowColor: Colors.blue, // Text color
                            side: const BorderSide(
                                color: Colors.blue), // Border color
                          ),
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(color: Colors.black),
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: const Text(
                        "Quên mật khẩu",
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
