import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserService {
  final String _baseUrl = 'https://crudcrud.com/api/da0243ffa0d046c69900764b40b0b3cf/users';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> usersJson = json.decode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode < 200 || response.statusCode > 299) { // Accepte toute réponse 2xx
      print('Failed to create user. Status code: ${response.statusCode}'); // Pour le débogage
      throw Exception('Failed to create user. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$userId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
