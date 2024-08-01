import 'package:buoi8/app/model/bill.dart';
import 'package:buoi8/app/model/cart.dart';
import 'package:buoi8/app/model/category.dart';
import 'package:buoi8/app/model/product.dart';
import 'package:buoi8/app/model/register.dart';
import 'package:buoi8/app/model/user.dart';
import 'package:dio/dio.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "https://huflit.id.vn:4321";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  bool isValidUrl(String url) {
    // Kiểm tra URL cơ bản
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https'));
  }

  Future<String> register(Signup user) async {
    try {
      if (!isValidUrl(user.imageUrl!)) {
        throw ArgumentError("URL không hợp lệ: ${user.imageUrl}");
      }
      final body = FormData.fromMap({
        "numberID": user.numberID,
        "accountID": user.accountID,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "imageURL": user.imageUrl,
        "birthDay": user.birthDay,
        "gender": user.gender,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "password": user.password,
        "confirmPassword": user.confirmPassword
      });
      Response res = await api.sendRequest.post('/Student/signUp',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else {
        print("fail");
        return "signup fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> login(String accountID, String password) async {
    try {
      final body =
          FormData.fromMap({'AccountID': accountID, 'Password': password});
      Response res = await api.sendRequest.post('/Auth/login',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        final tokenData = res.data['data']['token'];
        print("ok login");
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> forgot(
      String accountID, String numberID, String newPass) async {
    try {
      final body = FormData.fromMap(
          {'accountID': accountID, 'numberID': numberID, 'newPass': newPass});
      Response res = await api.sendRequest.put('/Auth/forgetPass',
          options: Options(headers: header('no token')), data: body);
      if (res.statusCode == 200) {
        return "Success";
      } else {
        return "forget fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<User> current(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Auth/current', options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategory(
      String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Category/getList?accountID=$accountID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => CategoryModel.fromJson(e))
          .cast<CategoryModel>()
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  Future<bool> addCategory(
      CategoryModel data, String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': accountID
      });
      Response res = await api.sendRequest.post('/addCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok add category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateCategory(int categoryID, CategoryModel data,
      String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'id': categoryID,
        'name': data.name,
        'description': data.desc,
        'imageURL': data.imageUrl,
        'accountID': accountID
      });
      Response res = await api.sendRequest.put('/updateCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok update category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeCategory(
      int categoryID, String accountID, String token) async {
    try {
      final body =
          FormData.fromMap({'categoryID': categoryID, 'accountID': accountID});
      Response res = await api.sendRequest.delete('/removeCategory',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok remove category");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProductModel>> getProduct(String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Product/getList?accountID=$accountID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => ProductModel.fromJson(e))
          .cast<ProductModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductAdmin(
      String accountID, String token) async {
    try {
      Response res = await api.sendRequest.get(
          '/Product/getListAdmin?accountID=$accountID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => ProductModel.fromJson(e))
          .cast<ProductModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addProduct(ProductModel data, String token) async {
    try {
      final body = FormData.fromMap({
        'name': data.name,
        'description': data.description,
        'imageURL': data.imageUrl,
        'Price': data.price,
        'CategoryID': data.categoryId
      });
      Response res = await api.sendRequest.post('/addProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok add product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateProduct(
      ProductModel data, String accountID, String token) async {
    try {
      final body = FormData.fromMap({
        'id': data.id,
        'name': data.name,
        'description': data.description,
        'imageURL': data.imageUrl,
        'Price': data.price,
        'categoryID': data.categoryId,
        'accountID': accountID
      });
      Response res = await api.sendRequest.put('/updateProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok update product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> removeProduct(
      int productID, String accountID, String token) async {
    try {
      final body =
          FormData.fromMap({'productID': productID, 'accountID': accountID});
      Response res = await api.sendRequest.delete('/removeProduct',
          options: Options(headers: header(token)), data: body);
      if (res.statusCode == 200) {
        print("ok remove product");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addBill(List<Cart> products, String token) async {
    var list = [];
    try {
      for (int i = 0; i < products.length; i++) {
        list.add({
          'productID': products[i].productID,
          'count': products[i].count,
        });
      }
      Response res = await api.sendRequest.post('/Order/addBill',
          options: Options(headers: header(token)), data: list);
      if (res.statusCode == 200) {
        print("add bill ok");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillModel>> getHistory(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Bill/getHistory', options: Options(headers: header(token)));
      return res.data
          .map((e) => BillModel.fromJson(e))
          .cast<BillModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillDetailModel>> getHistoryDetail(
      String billID, String token) async {
    try {
      Response res = await api.sendRequest.post('/Bill/getByID?billID=$billID',
          options: Options(headers: header(token)));
      return res.data
          .map((e) => BillDetailModel.fromJson(e))
          .cast<BillDetailModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<BillModel?> getBillByID(String billID, String token) async {
    try {
      Response res = await api.sendRequest.get(
        '/Bill/getByID',
        queryParameters: {'billID': billID},
        options: Options(headers: header(token)),
      );

      if (res.statusCode == 200) {
        return BillModel.fromJson(res.data);
      } else {
        print("Lỗi khi lấy chi tiết hóa đơn với mã lỗi: ${res.statusCode}");
        return null;
      }
    } catch (ex) {
      print("Lỗi khi gọi API lấy chi tiết hóa đơn: $ex");
      return null;
    }
  }

  Future<bool> deleteBill(String billID, String token) async {
    try {
      Response res = await api.sendRequest.delete('/Bill/remove',
          options: Options(headers: header(token)),
          queryParameters: {'billID': billID});
      if (res.statusCode == 200) {
        print("Xóa hóa đơn thành công");
        return true;
      } else {
        print("Xóa hóa đơn thất bại với mã lỗi: ${res.statusCode}");
        return false;
      }
    } catch (ex) {
      print("Lỗi khi xóa hóa đơn: $ex");
      return false;
    }
  }

  Future<bool> updateUserInfo(User user, String token) async {
    try {
      if (user.imageURL != null && !isValidUrl(user.imageURL!)) {
        throw ArgumentError("URL không hợp lệ: ${user.imageURL}");
      }
      final body = FormData.fromMap({
        "numberID": user.idNumber,
        "fullName": user.fullName,
        "phoneNumber": user.phoneNumber,
        "gender": user.gender,
        "birthday": user.birthDay,
        "schoolYear": user.schoolYear,
        "schoolKey": user.schoolKey,
        "imageURL": user.imageURL,
      });
      Response res = await api.sendRequest.put(
        'Auth/updateProfile',
        options: Options(headers: header(token)),
        data: body,
      );
      if (res.statusCode == 200) {
        print("Cập nhật thông tin thành công!");
        return true;
      } else {
        print("Cập nhật thông tin thất bại!");
        return false;
      }
    } catch (ex) {
      print("Lỗi khi cập nhật thông tin: $ex");
      rethrow;
    }
  }
}
