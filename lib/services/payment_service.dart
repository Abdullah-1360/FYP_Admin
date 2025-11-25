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
      final response = await _dio.get(
        '/payments',
        queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (response.statusCode == 200) {
        final raw = response.data;
        List<dynamic> list;
        if (raw is List) {
          list = raw;
        } else if (raw is Map && raw['data'] is List) {
          list = raw['data'] as List<dynamic>;
        } else {
          throw Exception('Unexpected response format when loading payments');
        }
        return list
            .map((e) => Payment.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      throw Exception('Failed to load payments: ${response.statusMessage ?? response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load payments: $e');
    }
  }

  static Future<void> deletePayment(String id) async {
    try {
      final response = await _dio.delete('/payments/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }
      final data = response.data;
      final message = (data is Map && data['message'] is String)
          ? (data['message'] as String)
          : 'Failed to delete payment';
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to delete payment: $e');
    }
  }

  static Future<Payment> updatePaymentStatus(String id, String status) async {
    try {
      final response = await _dio.put('/payments/$id/status', data: {'status': status});
      if (response.statusCode == 200) {
        final data = response.data;
        final payment = (data is Map && data['payment'] is Map)
            ? Payment.fromJson(Map<String, dynamic>.from(data['payment']))
            : Payment.fromJson(Map<String, dynamic>.from(response.data as Map));
        return payment;
      }
      final data = response.data;
      final message = (data is Map && data['message'] is String)
          ? (data['message'] as String)
          : 'Failed to update status';
      throw Exception(message);
    } catch (e) {
      throw Exception('Failed to update status: $e');
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
