// import 'package:buoi8/app/data/api.dart';
// import 'package:buoi8/app/model/user.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UpdateProfilePage extends StatefulWidget {
//   final String accountId; // Thêm accountId để xác định người dùng cần cập nhật

//   const UpdateProfilePage({Key? key, required this.accountId})
//       : super(key: key);

//   @override
//   _UpdateProfilePageState createState() => _UpdateProfilePageState();
// }

// class _UpdateProfilePageState extends State<UpdateProfilePage> {
//   final _formKey = GlobalKey<FormState>();

//   late String _idNumber;
//   late String _fullName;
//   late String _phoneNumber;
//   late String _gender;
//   late String _birthDay;
//   late String _schoolYear;
//   late String _schoolKey;
//   late String _imageUrl;

//   @override
//   void initState() {
//     super.initState();
//     // Khởi tạo giá trị từ widget.user (nếu cần)
//     _idNumber = '';
//     _fullName = '';
//     _phoneNumber = '';
//     _gender = '';
//     _birthDay = '';
//     _schoolYear = '';
//     _schoolKey = '';
//     _imageUrl = '';

//     // Load thông tin người dùng hiện tại (nếu có)
//     loadUserData();
//   }

//   // Hàm load thông tin người dùng từ hệ thống hoặc local storage
//   void loadUserData() async {
//     try {
//       // Đọc thông tin người dùng từ hệ thống hoặc local storage và cập nhật vào state
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       _idNumber = prefs.getString('idNumber') ?? '';
//       _fullName = prefs.getString('fullName') ?? '';
//       _phoneNumber = prefs.getString('phoneNumber') ?? '';
//       _gender = prefs.getString('gender') ?? '';
//       _birthDay = prefs.getString('birthDay') ?? '';
//       _schoolYear = prefs.getString('schoolYear') ?? '';
//       _schoolKey = prefs.getString('schoolKey') ?? '';
//       _imageUrl = prefs.getString('imageUrl') ?? '';

//       setState(() {}); // Cập nhật UI sau khi load dữ liệu
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//   }

//   void _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       // Tạo đối tượng user cập nhật
//       User updatedUser = User(
//         accountId: widget.accountId,
//         idNumber: _idNumber,
//         fullName: _fullName,
//         phoneNumber: _phoneNumber,
//         gender: _gender,
//         birthDay: _birthDay,
//         schoolYear: _schoolYear,
//         schoolKey: _schoolKey,
//         imageURL: _imageUrl,
//         dateCreated: '',
//         status: false,
//       );

//       try {
//         // Lấy token từ local storage (SharedPreferences)
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String? token = prefs.getString('token');

//         if (token != null) {
//           // Thực hiện gọi API cập nhật thông tin người dùng
//           bool success =
//               await APIRepository().updateUserInfo(updatedUser, token);

//           if (success) {
//             print("Cập nhật thông tin thành công!");
//             Navigator.pop(context);
//           } else {
//             print("Cập nhật thông tin thất bại!");
//             // Xử lý trường hợp cập nhật không thành công nếu cần
//           }
//         } else {
//           print('Không tìm thấy token. Vui lòng đăng nhập lại.');
//           // Xử lý trường hợp không tìm thấy token (cần đăng nhập lại)
//         }
//       } catch (e) {
//         print("Lỗi khi cập nhật thông tin: $e");
//         // Xử lý trường hợp lỗi nếu cần
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Cập nhật thông tin cá nhân"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 initialValue: _idNumber,
//                 decoration: const InputDecoration(labelText: 'Number ID'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập Number ID';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _idNumber = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _fullName,
//                 decoration: const InputDecoration(labelText: 'Full Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập Full Name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _fullName = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _phoneNumber,
//                 decoration: const InputDecoration(labelText: 'Phone Number'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập Phone Number';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _phoneNumber = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _gender,
//                 decoration: const InputDecoration(labelText: 'Gender'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập Gender';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _gender = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _birthDay,
//                 decoration: const InputDecoration(labelText: 'Birth Day'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập Birth Day';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _birthDay = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _schoolYear,
//                 decoration: const InputDecoration(labelText: 'School Year'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập School Year';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _schoolYear = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _schoolKey,
//                 decoration: const InputDecoration(labelText: 'School Key'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập School Key';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _schoolKey = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _imageUrl,
//                 decoration: const InputDecoration(labelText: 'Image URL'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập Image URL';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _imageUrl = value!;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _updateProfile,
//                 child: const Text('Cập nhật'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
