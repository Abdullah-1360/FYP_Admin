import 'package:dio/dio.dart';
import '../Global_variables.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/medicine_model.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class AdminService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: globalvariables().getBaseUrl(),
    validateStatus: (status) => true,
  ));

  // User Management
  static Future<List<AdminUser>> getAllUsers() async {
    try {
      final response = await _dio.get('/admin/users');

      if (response.statusCode == 200) {
        final dynamic raw = response.data;
        final List<dynamic> data = raw is List ? raw : (raw['users'] ?? []);
        print('Fetched users: \\${data.length}');
        return data.map((json) => AdminUser.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  static Future<void> blockUser(String userId) async {
    try {
      final response = await _dio.post('/admin/users/block/$userId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to block user: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  static Future<void> unblockUser(String userId) async {
    try {
      final response = await _dio.post('/admin/users/unblock/$userId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to unblock user: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  static Future<void> deleteUser(String userId) async {
    try {
      final response = await _dio.delete('/admin/users/$userId');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<void> toggleUserStatus(String userId) async {
    try {
      final response = await _dio.post('/admin/users/toggle-status/$userId');
      if (response.statusCode != 200) {
        throw Exception('Failed to toggle user status: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to toggle user status: $e');
    }
  }

  Future<void> resetUserPassword(String userId) async {
    try {
      final response = await _dio.post('/admin/users/reset-password/$userId');
      if (response.statusCode != 200) {
        throw Exception('Failed to reset user password: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to reset user password: $e');
    }
  }

  // Doctor Management
  static Future<List<Doctor>> getAllDoctors() async {
    try {
      final response = await _dio.get('/admin/doctors');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Doctor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load doctors: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }

  static Future<void> addDoctor(Map<String, dynamic> doctorData) async {
    try {
      final response = await _dio.post('/admin/doctors', data: doctorData);
      
      if (response.statusCode != 201) {
        throw Exception('Failed to add doctor: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to add doctor: $e');
    }
  }

  static Future<void> updateDoctor(String doctorId, Map<String, dynamic> doctorData) async {
    try {
      final response = await _dio.put('/admin/doctors/$doctorId', data: doctorData);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update doctor: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to update doctor: $e');
    }
  }

  static Future<void> deleteDoctor(String doctorId) async {
    try {
      final response = await _dio.delete('/admin/doctors/$doctorId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete doctor: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete doctor: $e');
    }
  }

  // Appointment Management
  Future<List<dynamic>> getAllAppointments() async {
    try {
      final response = await _dio.get('/admin/appointments');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data;
      } else {
        throw Exception('Failed to load appointments: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      final response = await _dio.put('/admin/appointments/$appointmentId/status', 
          data: {'status': status});
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update appointment status: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to update appointment status: $e');
    }
  }

  Future<void> rescheduleAppointment(String appointmentId, DateTime newDateTime) async {
    try {
      final response = await _dio.put('/admin/appointments/$appointmentId/reschedule', 
          data: {'appointmentDate': newDateTime.toIso8601String()});
      
      if (response.statusCode != 200) {
        throw Exception('Failed to reschedule appointment: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to reschedule appointment: $e');
    }
  }

  // Medicine Management
  static Future<List<Medicine>> getAllMedicines() async {
    try {
      final response = await _dio.get('/admin/medicines');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Medicine.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medicines: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load medicines: $e');
    }
  }

  static Future<void> addMedicine(Map<String, dynamic> medicineData) async {
    try {
      final response = await _dio.post('/admin/medicines', data: medicineData);
      
      if (response.statusCode != 201) {
        throw Exception('Failed to add medicine: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to add medicine: $e');
    }
  }

  static Future<void> updateMedicine(String medicineId, Map<String, dynamic> medicineData) async {
    try {
      final response = await _dio.put('/admin/medicines/$medicineId', data: medicineData);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update medicine: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to update medicine: $e');
    }
  }

  static Future<void> deleteMedicine(String medicineId) async {
    try {
      final response = await _dio.delete('/admin/medicines/$medicineId');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete medicine: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete medicine: $e');
    }
  }

  // Sales Management
  Future<List<dynamic>> getSalesData() async {
    try {
      final response = await _dio.get('/admin/sales');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data;
      } else {
        throw Exception('Failed to load sales data: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load sales data: $e');
    }
  }

  // Upload image from bytes (for Flutter Web)
  static Future<String> uploadImageBytes(Uint8List bytes, String filename) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      });

      final response = await _dio.post('/admin/upload', data: formData);
      if (response.statusCode == 200) {
        return response.data['url'];
      } else {
        throw Exception('Failed to upload image: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<String> uploadImage(File image) async {
    if (kIsWeb) {
      throw Exception('Use uploadImageBytes on web');
    }
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
      });

      final response = await _dio.post('/admin/upload', data: formData);
      if (response.statusCode == 200) {
        return response.data['url'];
      } else {
        throw Exception('Failed to upload image: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Add authentication token to requests
  static void setAuthToken(String token) {
    if (token.isEmpty) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}