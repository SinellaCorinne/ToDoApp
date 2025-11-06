import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/tasks.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.212.166.6:8000/api', 
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        _dio.options.headers['Authorization'] = 'Token $token';
        return token;
      }
    } on DioException catch (e) {
      print('Login error: ${e.response?.data}');
    }
    return null;
  }

  Future<String?> register(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 201) {
        return 'success';
      }
    } on DioException catch (e) {
      print('Register error: ${e.response?.data}');
    }
    return null;
  }

  Future<List<Task>> getTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Token $token';
      }

      final response = await _dio.get('/tasks/');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Task.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      print('GetTasks error: ${e.response?.data}');
    }
    return [];
  }

  Future<bool> addTask(Task task) async {
    try {
       final prefs = await SharedPreferences.getInstance();
       final token = prefs.getString('token');
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Token $token';
      }
      final response = await _dio.post('/tasks/', data: task.toJson());
      return response.statusCode == 201;
  
    } on DioException catch (e) {
      print('AddTask error: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      final prefs = await SharedPreferences.getInstance();
       final token = prefs.getString('token');
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Token $token';
      }
      final response = await _dio.put('/tasks/${task.id}/', data: task.toJson());
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('UpdateTask error: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
       final token = prefs.getString('token');
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Token $token';
      }
      final response = await _dio.delete('/tasks/$id/');
      return response.statusCode == 204;
    } on DioException catch (e) {
      print('DeleteTask error: ${e.response?.data}');
      return false;
    }
  }
}
