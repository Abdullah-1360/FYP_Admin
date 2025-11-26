import 'package:dio/dio.dart';
import '../Global_variables.dart';
import '../models/analytics_models.dart';

class AnalyticsService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: globalvariables().getBaseUrl(),
    validateStatus: (status) => true,
  ));

  // Fetch aggregated analytics from backend
  static Future<Map<String, dynamic>> _fetchAnalytics() async {
    final response = await _dio.get('/analytics');
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to load analytics: ${response.statusMessage}');
    }
  }

  // User Analytics
  static Future<UserAnalytics> getUserAnalytics() async {
    try {
      final data = await _fetchAnalytics();
      final users = Map<String, dynamic>.from(data['users'] ?? {});
      return UserAnalytics(
        totalUsers: (users['totalUsers'] ?? 0) as int,
        activeUsers: (users['activeUsers'] ?? 0) as int,
        blockedUsers: (users['blockedUsers'] ?? 0) as int,
        monthlyRegistrations: Map<String, int>.from(users['monthlyRegistrations'] ?? {}),
        usersByRole: Map<String, int>.from(users['usersByRole'] ?? {}),
      );
    } catch (e) {
      throw Exception('Failed to load user analytics: $e');
    }
  }

  // Doctor Analytics
  static Future<DoctorAnalytics> getDoctorAnalytics() async {
    try {
      final data = await _fetchAnalytics();
      final doctors = Map<String, dynamic>.from(data['doctors'] ?? {});
      return DoctorAnalytics(
        totalDoctors: (doctors['totalDoctors'] ?? 0) as int,
        doctorsBySpecialization: Map<String, int>.from(doctors['doctorsBySpecialization'] ?? {}),
        doctorsByExperience: Map<String, int>.from(doctors['doctorsByExperience'] ?? {}),
        averageRating: ((doctors['averageRating'] ?? 0.0) as num).toDouble(),
      );
    } catch (e) {
      throw Exception('Failed to load doctor analytics: $e');
    }
  }

  // Medicine Analytics
  static Future<MedicineAnalytics> getMedicineAnalytics() async {
    try {
      final data = await _fetchAnalytics();
      final medicines = Map<String, dynamic>.from(data['medicines'] ?? {});
      return MedicineAnalytics(
        totalMedicines: (medicines['totalMedicines'] ?? 0) as int,
        lowStockMedicines: (medicines['lowStockMedicines'] ?? 0) as int,
        outOfStockMedicines: (medicines['outOfStockMedicines'] ?? 0) as int,
        medicinesByCategory: Map<String, int>.from(medicines['medicinesByCategory'] ?? {}),
        revenueByCategory: Map<String, double>.from(
          (medicines['revenueByCategory'] ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble())),
        ),
        totalInventoryValue: ((medicines['totalInventoryValue'] ?? 0.0) as num).toDouble(),
      );
    } catch (e) {
      throw Exception('Failed to load medicine analytics: $e');
    }
  }

  // Appointment Analytics (Note: This would need appointment endpoints)
  static Future<AppointmentAnalytics> getAppointmentAnalytics() async {
    try {
      final data = await _fetchAnalytics();
      final appointments = Map<String, dynamic>.from(data['appointments'] ?? {});
      return AppointmentAnalytics(
        totalAppointments: (appointments['totalAppointments'] ?? 0) as int,
        pendingAppointments: (appointments['pendingAppointments'] ?? 0) as int,
        confirmedAppointments: (appointments['confirmedAppointments'] ?? 0) as int,
        completedAppointments: (appointments['completedAppointments'] ?? 0) as int,
        cancelledAppointments: (appointments['cancelledAppointments'] ?? 0) as int,
        appointmentsByMonth: Map<String, int>.from(appointments['appointmentsByMonth'] ?? {}),
        appointmentsByDoctor: Map<String, int>.from(appointments['appointmentsByDoctor'] ?? {}),
        appointmentsByStatus: Map<String, int>.from(appointments['appointmentsByStatus'] ?? {}),
      );
    } catch (e) {
      throw Exception('Failed to load appointment analytics: $e');
    }
  }

  // Revenue Analytics (Mock data - would need actual payment/order endpoints)
  static Future<RevenueAnalytics> getRevenueAnalytics() async {
    try {
      final data = await _fetchAnalytics();
      final revenue = Map<String, dynamic>.from(data['revenue'] ?? {});
      return RevenueAnalytics(
        totalRevenue: ((revenue['totalRevenue'] ?? 0.0) as num).toDouble(),
        monthlyRevenue: Map<String, double>.from(
          (revenue['monthlyRevenue'] ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble())),
        ),
        revenueByCategory: Map<String, double>.from(
          (revenue['revenueByCategory'] ?? {}).map((k, v) => MapEntry(k, (v as num).toDouble())),
        ),
        averageOrderValue: ((revenue['averageOrderValue'] ?? 0.0) as num).toDouble(),
        totalOrders: (revenue['totalOrders'] ?? 0) as int,
      );
    } catch (e) {
      throw Exception('Failed to load revenue analytics: $e');
    }
  }

  // Dashboard Summary
  static Future<DashboardSummary> getDashboardSummary() async {
    try {
      final response = await _dio.get('/analytics/summary');
      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        return DashboardSummary(
          totalUsers: (data['totalUsers'] ?? 0) as int,
          totalDoctors: (data['totalDoctors'] ?? 0) as int,
          totalMedicines: (data['totalMedicines'] ?? 0) as int,
          totalAppointments: (data['totalAppointments'] ?? 0) as int, // may be 0 if not provided
          totalRevenue: ((data['totalRevenue'] ?? 0.0) as num).toDouble(),
          activeUsers: (data['activeUsers'] ?? 0) as int,
          lowStockMedicines: (data['lowStockMedicines'] ?? 0) as int,
          pendingAppointments: (data['pendingAppointments'] ?? 0) as int,
        );
      } else {
        throw Exception('Failed to load dashboard summary: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load dashboard summary: $e');
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
