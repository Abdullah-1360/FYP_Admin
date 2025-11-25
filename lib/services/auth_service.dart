import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Global_variables.dart';
import 'admin_service.dart';
import 'payment_service.dart';

class AuthService {
  static final Dio _dio = Dio(BaseOptions(

    validateStatus: (status) => true,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    contentType: 'application/json',
    headers: {
      'Accept': 'application/json',
    },
  ));

  static final _storage = FlutterSecureStorage();
  static const _tokenKey = 'admin_token';
  static const _usernameKey = 'admin_email';

  // Initialize Dio interceptors for better error handling
  static void _initializeInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        return handler.next(e);
      },
    ));
  }

  static String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Please try again.';
        case DioExceptionType.badCertificate:
          return 'Invalid certificate. Please check your connection security.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] ?? 'Unknown error occurred';
          return 'Server error ($statusCode): $message';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return 'Unable to connect to the server. Please check your internet connection.';
          }
          return 'An unexpected error occurred. Please try again.';
      }
    }
    return error.toString();
  }

  static Future<bool> login(String email, String password) async {
    try {
      _initializeInterceptors();
      
      final response = await _dio.post('${globalvariables().getBaseUrl()}/admin/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final admin = data['admin'];

        // Store auth data
        await Future.wait([
          _storage.write(key: _tokenKey, value: token),
          _storage.write(key: _usernameKey, value: admin['email']),
        ]);

        // Set token for future requests
        _dio.options.headers['Authorization'] = 'Bearer $token';
        // Propagate token to other services
        AdminService.setAuthToken(token);
        PaymentService.setAuthToken(token);
        return true;
      }

      throw Exception(response.data['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception(_handleError(e));
    }
  }

  static Future<void> logout() async {
    try {
      await Future.wait([
        _storage.delete(key: _tokenKey),
        _storage.delete(key: _usernameKey),
      ]);
      _dio.options.headers.remove('Authorization');
      AdminService.setAuthToken('');
    } catch (e) {
      throw Exception('Error during logout: ${_handleError(e)}');
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null) {
        return false;
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      AdminService.setAuthToken(token);
      PaymentService.setAuthToken(token);
      
      final response = await _dio.get('${globalvariables().getBaseUrl()}/admin/auth/validate-token');

      return response.statusCode == 200 && response.data['valid'] == true;
    } catch (e) {
      print('Auth check error: ${_handleError(e)}');
      return false;
    }
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  static Future<String?> getUsername() async {
    return _storage.read(key: _usernameKey);
  }

  static Future<void> init() async {
    _initializeInterceptors();
    final token = await getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      AdminService.setAuthToken(token);
    }
  }

  // Test connection to server
  static Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test error: ${_handleError(e)}');
      return false;
    }
  }
}
