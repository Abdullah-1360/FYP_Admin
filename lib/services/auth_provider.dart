import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  AuthStatus _status = AuthStatus.loading;
  String? _token;
  Map<String, dynamic>? _userData;

  AuthStatus get status => _status;
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final storedToken = await _storage.read(key: 'auth_token');
      final storedUserData = await _storage.read(key: 'user_data');

      if (storedToken != null) {
        _token = storedToken;
        _userData = storedUserData != null ? 
            Map<String, dynamic>.from({}) : null; // Parse JSON in real implementation
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, you would make an API call here
      // and store the returned token and user data
      if (email == 'admin@example.com' && password == 'password') {
        _token = 'sample_token';
        _userData = {
          'id': '1',
          'name': 'Admin User',
          'email': email,
          'role': 'admin',
        };

        await _storage.write(key: 'auth_token', value: _token);
        await _storage.write(key: 'user_data', value: '{"id":"1","name":"Admin User"}');

        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
    
    _token = null;
    _userData = null;
    _status = AuthStatus.unauthenticated;
    
    notifyListeners();
  }
}