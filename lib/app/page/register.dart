import 'package:buoi8/app/data/api.dart';
import 'package:buoi8/app/model/register.dart';
import 'package:buoi8/app/page/auth/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  String gendername = 'None';
  String temp = '';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String> register() async {
    if (!_formKey.currentState!.validate()) {
      return "Thông tin đăng ký không hợp lệ. Vui lòng kiểm tra lại.";
    }

    return await APIRepository().register(Signup(
      accountID: _accountController.text,
      birthDay: _birthDayController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      schoolKey: _schoolKeyController.text,
      schoolYear: _schoolYearController.text,
      gender: getGender(),
      imageUrl: _imageURL.text,
      numberID: _numberIDController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng Ký"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'THÔNG TIN ĐĂNG KÝ',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  signUpWidget(),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            String response = await register();
                            if (response == "ok") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text('Đăng ký '),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getGender() {
    if (_gender == 1) {
      return "Nam";
    } else if (_gender == 2) {
      return "Nữ";
    }
    return "Khác";
  }

  Widget textField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.contains('word'),
        onChanged: (value) {
          setState(() {
            temp = value;
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          // Các điều kiện validate khác có thể thêm ở đây
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget signUpWidget() {
    return Column(
      children: [
        textField(_accountController, "Tài khoản", Icons.person),
        textField(_passwordController, "Mật khẩu", Icons.password),
        textField(
          _confirmPasswordController,
          "Xác nhận mật khẩu",
          Icons.password,
        ),
        textField(_fullNameController, "Họ và tên", Icons.text_fields_outlined),
        textField(_numberIDController, "Số CMND", Icons.key),
        textField(_phoneNumberController, "Số điện thoại", Icons.phone),
        textField(_birthDayController, "Ngày sinh", Icons.date_range),
        textField(_schoolYearController, "Năm học", Icons.school),
        textField(_schoolKeyController, "Khóa học", Icons.school),
        const Text("Giới tính"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Nam"),
                leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 1,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Nữ"),
                leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 2,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Khác"),
                leading: Transform.translate(
                  offset: const Offset(16, 0),
                  child: Radio(
                    value: 3,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _imageURL,
          decoration: const InputDecoration(
            labelText: "Đường dẫn hình ảnh",
            icon: Icon(Icons.image),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 3,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
