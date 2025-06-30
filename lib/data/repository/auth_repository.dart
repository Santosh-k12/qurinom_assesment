import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user_model.dart';
import '../models/login_request_model.dart';

class AuthRepository {
  final String baseUrl = 'http://45.129.87.38:6065';

  Future<User> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['data'] != null) {
      final userJson = data['data']['user'];
      return User.fromJson(userJson);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
