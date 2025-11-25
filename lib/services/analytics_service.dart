import 'package:dio/dio.dart';
import '../Global_variables.dart';
import '../models/analytics_models.dart';

class AnalyticsService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: globalvariables().getBaseUrl(),
    validateStatus: (status) => true,
  ));

  // User Analytics
  static Future<UserAnalytics> getUserAnalytics() async {
    try {
      final response = await _dio.get('/analytics');
      
      if (response.statusCode == 200) {
        final data = response.data['users'];
        
        return UserAnalytics(
          totalUsers: data['totalUsers'] ?? 0,
          activeUsers: data['activeUsers'] ?? 0,
          blockedUsers: data['blockedUsers'] ?? 0,
          monthlyRegistrations: Map<String, int>.from(data['monthlyRegistrations'] ?? {}),
          usersByRole: Map<String, int>.from(data['usersByRole'] ?? {}),
        );
      } else {
        throw Exception('Failed to load user analytics: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load user analytics: $e');
    }
  }

  // Doctor Analytics
  static Future<DoctorAnalytics> getDoctorAnalytics() async {
    try {
      final response = await _dio.get('/analytics');
      
      if (response.statusCode == 200) {
        final data = response.data['doctors'];
        
        return DoctorAnalytics(
          totalDoctors: data['totalDoctors'] ?? 0,
          doctorsBySpecialization: Map<String, int>.from(data['doctorsBySpecialization'] ?? {}),
          doctorsByExperience: Map<String, int>.from(data['doctorsByExperience'] ?? {}),
          averageRating: (data['averageRating'] ?? 0).toDouble(),
        );
      } else {
        throw Exception('Failed to load doctor analytics: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load doctor analytics: $e');
    }
  }

  // Medicine Analytics
  static Future<MedicineAnalytics> getMedicineAnalytics() async {
    try {
      final response = await _dio.get('/analytics');
      
      if (response.statusCode == 200) {
        final data = response.data['medicines'];
        
        return MedicineAnalytics(
          totalMedicines: data['totalMedicines'] ?? 0,
          lowStockMedicines: data['lowStockMedicines'] ?? 0,
          outOfStockMedicines: data['outOfStockMedicines'] ?? 0,
          medicinesByCategory: Map<String, int>.from(data['medicinesByCategory'] ?? {}),
          revenueByCategory: Map<String, double>.from(
            (data['revenueByCategory'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
          ),
          totalInventoryValue: (data['totalInventoryValue'] ?? 0).toDouble(),
        );
      } else {
        throw Exception('Failed to load medicine analytics: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load medicine analytics: $e');
    }
  }

  // Appointment Analytics
  static Future<AppointmentAnalytics> getAppointmentAnalytics() async {
    try {
      final response = await _dio.get('/analytics');
      
      if (response.statusCode == 200) {
        final data = response.data['appointments'];
        
        return AppointmentAnalytics(
          totalAppointments: data['totalAppointments'] ?? 0,
          pendingAppointments: data['pendingAppointments'] ?? 0,
          confirmedAppointments: data['confirmedAppointments'] ?? 0,
          completedAppointments: data['completedAppointments'] ?? 0,
          cancelledAppointments: data['cancelledAppointments'] ?? 0,
          appointmentsByMonth: Map<String, int>.from(data['appointmentsByMonth'] ?? {}),
          appointmentsByDoctor: Map<String, int>.from(data['appointmentsByDoctor'] ?? {}),
          appointmentsByStatus: Map<String, int>.from(data['appointmentsByStatus'] ?? {}),
        );
      } else {
        throw Exception('Failed to load appointment analytics: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load appointment analytics: $e');
    }
  }

  // Revenue Analytics
  static Future<RevenueAnalytics> getRevenueAnalytics() async {
    try {
      final response = await _dio.get('/analytics');
      
      if (response.statusCode == 200) {
        final data = response.data['revenue'];
        
        return RevenueAnalytics(
          totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
          monthlyRevenue: Map<String, double>.from(
            (data['monthlyRevenue'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
          ),
          revenueByCategory: Map<String, double>.from(
            (data['revenueByCategory'] as Map? ?? {}).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
          ),
          averageOrderValue: (data['averageOrderValue'] ?? 0).toDouble(),
          totalOrders: data['totalOrders'] ?? 0,
        );
      } else {
        throw Exception('Failed to load revenue analytics: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load revenue analytics: $e');
    }
  }

  // Dashboard Summary
  static Future<DashboardSummary> getDashboardSummary() async {
    try {
      final response = await _dio.get('/analytics/summary');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        return DashboardSummary(
          totalUsers: data['totalUsers'] ?? 0,
          totalDoctors: data['totalDoctors'] ?? 0,
          totalMedicines: data['totalMedicines'] ?? 0,
          totalAppointments: 0,
          totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
          activeUsers: data['activeUsers'] ?? 0,
          lowStockMedicines: data['lowStockMedicines'] ?? 0,
          pendingAppointments: data['pendingAppointments'] ?? 0,
        );
      } else {
        throw Exception('Failed to load dashboard summary: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load dashboard summary: $e');
    }
  }
}