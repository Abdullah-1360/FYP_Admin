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
      final response = await _dio.get('/admin/users');
      
      if (response.statusCode == 200) {
        final List<dynamic> users = response.data is List ? response.data : (response.data['users'] ?? []);
        
        int totalUsers = users.length;
        int activeUsers = users.where((user) => !user['isBlocked']).length;
        int blockedUsers = users.where((user) => user['isBlocked'] == true).length;
        
        // Group users by registration month
        Map<String, int> monthlyRegistrations = {};
        Map<String, int> usersByRole = {'user': 0, 'doctor': 0, 'admin': 0};
        
        for (var user in users) {
          // Monthly registrations
          if (user['createdAt'] != null) {
            DateTime createdAt = DateTime.parse(user['createdAt']);
            String monthKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
            monthlyRegistrations[monthKey] = (monthlyRegistrations[monthKey] ?? 0) + 1;
          }
          
          // Users by role
          String role = user['role'] ?? 'user';
          usersByRole[role] = (usersByRole[role] ?? 0) + 1;
        }
        
        return UserAnalytics(
          totalUsers: totalUsers,
          activeUsers: activeUsers,
          blockedUsers: blockedUsers,
          monthlyRegistrations: monthlyRegistrations,
          usersByRole: usersByRole,
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
      final response = await _dio.get('/admin/doctors');
      
      if (response.statusCode == 200) {
        final List<dynamic> doctors = response.data;
        
        int totalDoctors = doctors.length;
        Map<String, int> doctorsBySpecialization = {};
        Map<String, int> doctorsByExperience = {
          '0-2 years': 0,
          '3-5 years': 0,
          '6-10 years': 0,
          '10+ years': 0
        };
        
        double totalRating = 0;
        int ratedDoctors = 0;
        
        for (var doctor in doctors) {
          // Specialization distribution
          String specialization = doctor['specialization'] ?? 'General';
          doctorsBySpecialization[specialization] = (doctorsBySpecialization[specialization] ?? 0) + 1;
          
          // Experience distribution
          int experience = doctor['experience'] ?? 0;
          if (experience <= 2) {
            doctorsByExperience['0-2 years'] = doctorsByExperience['0-2 years']! + 1;
          } else if (experience <= 5) {
            doctorsByExperience['3-5 years'] = doctorsByExperience['3-5 years']! + 1;
          } else if (experience <= 10) {
            doctorsByExperience['6-10 years'] = doctorsByExperience['6-10 years']! + 1;
          } else {
            doctorsByExperience['10+ years'] = doctorsByExperience['10+ years']! + 1;
          }
          
          // Average rating
          if (doctor['ratings'] != null && doctor['ratings'].isNotEmpty) {
            List<dynamic> ratings = doctor['ratings'];
            double avgRating = ratings.fold(0.0, (sum, rating) => sum + rating) / ratings.length;
            totalRating += avgRating;
            ratedDoctors++;
          }
        }
        
        double averageRating = ratedDoctors > 0 ? totalRating / ratedDoctors : 0.0;
        
        return DoctorAnalytics(
          totalDoctors: totalDoctors,
          doctorsBySpecialization: doctorsBySpecialization,
          doctorsByExperience: doctorsByExperience,
          averageRating: averageRating,
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
      final response = await _dio.get('/admin/medicines');
      
      if (response.statusCode == 200) {
        final List<dynamic> medicines = response.data;
        
        int totalMedicines = medicines.length;
        int lowStockMedicines = medicines.where((med) => (med['stock'] ?? 0) < 10).length;
        int outOfStockMedicines = medicines.where((med) => (med['stock'] ?? 0) == 0).length;
        
        Map<String, int> medicinesByCategory = {};
        Map<String, double> revenueByCategory = {};
        double totalInventoryValue = 0;
        
        for (var medicine in medicines) {
          String category = medicine['category'] ?? 'Other';
          double price = (medicine['price'] ?? 0).toDouble();
          int stock = medicine['stock'] ?? 0;
          
          // Category distribution
          medicinesByCategory[category] = (medicinesByCategory[category] ?? 0) + 1;
          
          // Revenue by category (estimated based on stock * price)
          double categoryValue = price * stock;
          revenueByCategory[category] = (revenueByCategory[category] ?? 0) + categoryValue;
          totalInventoryValue += categoryValue;
        }
        
        return MedicineAnalytics(
          totalMedicines: totalMedicines,
          lowStockMedicines: lowStockMedicines,
          outOfStockMedicines: outOfStockMedicines,
          medicinesByCategory: medicinesByCategory,
          revenueByCategory: revenueByCategory,
          totalInventoryValue: totalInventoryValue,
        );
      } else {
        throw Exception('Failed to load medicine analytics: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to load medicine analytics: $e');
    }
  }

  // Appointment Analytics (Note: This would need appointment endpoints)
  static Future<AppointmentAnalytics> getAppointmentAnalytics() async {
    try {
      // Since we don't have a direct appointment endpoint in admin controller,
      // we'll create mock data based on the structure we know exists
      
      // In a real implementation, you would call:
      // final response = await _dio.get('/admin/appointments');
      
      // For now, returning mock data structure
      return AppointmentAnalytics(
        totalAppointments: 0,
        pendingAppointments: 0,
        confirmedAppointments: 0,
        completedAppointments: 0,
        cancelledAppointments: 0,
        appointmentsByMonth: {},
        appointmentsByDoctor: {},
        appointmentsByStatus: {
          'pending': 0,
          'confirmed': 0,
          'completed': 0,
          'cancelled': 0,
        },
      );
    } catch (e) {
      throw Exception('Failed to load appointment analytics: $e');
    }
  }

  // Revenue Analytics (Mock data - would need actual payment/order endpoints)
  static Future<RevenueAnalytics> getRevenueAnalytics() async {
    try {
      // This would typically call payment/order endpoints
      // For now, we'll estimate based on medicine inventory
      
      final medicineAnalytics = await getMedicineAnalytics();
      
      return RevenueAnalytics(
        totalRevenue: medicineAnalytics.totalInventoryValue * 0.3, // Estimated 30% of inventory as revenue
        monthlyRevenue: {
          '2024-01': 15000,
          '2024-02': 18000,
          '2024-03': 22000,
          '2024-04': 25000,
          '2024-05': 28000,
          '2024-06': 32000,
        },
        revenueByCategory: medicineAnalytics.revenueByCategory,
        averageOrderValue: 150.0,
        totalOrders: 0,
      );
    } catch (e) {
      throw Exception('Failed to load revenue analytics: $e');
    }
  }

  // Dashboard Summary
  static Future<DashboardSummary> getDashboardSummary() async {
    try {
      final userAnalytics = await getUserAnalytics();
      final doctorAnalytics = await getDoctorAnalytics();
      final medicineAnalytics = await getMedicineAnalytics();
      final appointmentAnalytics = await getAppointmentAnalytics();
      final revenueAnalytics = await getRevenueAnalytics();
      
      return DashboardSummary(
        totalUsers: userAnalytics.totalUsers,
        totalDoctors: doctorAnalytics.totalDoctors,
        totalMedicines: medicineAnalytics.totalMedicines,
        totalAppointments: appointmentAnalytics.totalAppointments,
        totalRevenue: revenueAnalytics.totalRevenue,
        activeUsers: userAnalytics.activeUsers,
        lowStockMedicines: medicineAnalytics.lowStockMedicines,
        pendingAppointments: appointmentAnalytics.pendingAppointments,
      );
    } catch (e) {
      throw Exception('Failed to load dashboard summary: $e');
    }
  }
}