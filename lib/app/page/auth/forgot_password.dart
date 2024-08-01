import 'package:buoi8/app/config/const.dart';
import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/data/sharepre.dart';
import 'package:buoi8/app/page/auth/login.dart';
import 'package:buoi8/app/page/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController accountController = TextEditingController();
  TextEditingController numberIDController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();

  forgot() async {
    String result = await APIRepository().forgot(accountController.text,
        numberIDController.text, newpasswordController.text);
    if (result == "Success") {
      print("change pass success");
    } else {
      print("change failed");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  autofotget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                    "Thông tin người dùng",
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: accountController,
                    decoration: const InputDecoration(
                      labelText: "accountID",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.blue,
                        ),
                      ),
                      icon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: numberIDController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "numberID",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.blue,
                        ),
                      ),
                      icon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newpasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "newPass",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.blue,
                        ),
                      ),
                      icon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: forgot,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                            shadowColor: Colors.blue, // Text color
                            side: const BorderSide(
                                color: Colors.blue), // Border color
                          ),
                          child: const Text(
                            "cập nhật",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
