import 'package:dio/dio.dart';
import '../Global_variables.dart';
import '../models/payment_model.dart';

class PaymentService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: globalvariables().getBaseUrl(),
    validateStatus: (status) => true,
  ));

  static Future<List<Payment>> getAllPayments() async {
    try {
      final response = await _dio.get('/payments');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((e) => Payment.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to load payments: ${response.statusMessage}');
    } catch (e) {
      throw Exception('Failed to load payments: $e');
    }
  }

  static Future<void> deletePayment(String id) async {
    try {
      final response = await _dio.delete('/payments/$id');
      if (response.statusCode != 200) {
        throw Exception(response.data?['message'] ?? 'Failed to delete payment');
      }
    } catch (e) {
      throw Exception('Failed to delete payment: $e');
    }
  }

  static void setAuthToken(String token) {
    if (token.isEmpty) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
