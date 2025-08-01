class UserAnalytics {
  final int totalUsers;
  final int activeUsers;
  final int blockedUsers;
  final Map<String, int> monthlyRegistrations;
  final Map<String, int> usersByRole;

  UserAnalytics({
    required this.totalUsers,
    required this.activeUsers,
    required this.blockedUsers,
    required this.monthlyRegistrations,
    required this.usersByRole,
  });
}

class DoctorAnalytics {
  final int totalDoctors;
  final Map<String, int> doctorsBySpecialization;
  final Map<String, int> doctorsByExperience;
  final double averageRating;

  DoctorAnalytics({
    required this.totalDoctors,
    required this.doctorsBySpecialization,
    required this.doctorsByExperience,
    required this.averageRating,
  });
}

class MedicineAnalytics {
  final int totalMedicines;
  final int lowStockMedicines;
  final int outOfStockMedicines;
  final Map<String, int> medicinesByCategory;
  final Map<String, double> revenueByCategory;
  final double totalInventoryValue;

  MedicineAnalytics({
    required this.totalMedicines,
    required this.lowStockMedicines,
    required this.outOfStockMedicines,
    required this.medicinesByCategory,
    required this.revenueByCategory,
    required this.totalInventoryValue,
  });
}

class AppointmentAnalytics {
  final int totalAppointments;
  final int pendingAppointments;
  final int confirmedAppointments;
  final int completedAppointments;
  final int cancelledAppointments;
  final Map<String, int> appointmentsByMonth;
  final Map<String, int> appointmentsByDoctor;
  final Map<String, int> appointmentsByStatus;

  AppointmentAnalytics({
    required this.totalAppointments,
    required this.pendingAppointments,
    required this.confirmedAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.appointmentsByMonth,
    required this.appointmentsByDoctor,
    required this.appointmentsByStatus,
  });
}

class RevenueAnalytics {
  final double totalRevenue;
  final Map<String, double> monthlyRevenue;
  final Map<String, double> revenueByCategory;
  final double averageOrderValue;
  final int totalOrders;

  RevenueAnalytics({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.revenueByCategory,
    required this.averageOrderValue,
    required this.totalOrders,
  });
}

class DashboardSummary {
  final int totalUsers;
  final int totalDoctors;
  final int totalMedicines;
  final int totalAppointments;
  final double totalRevenue;
  final int activeUsers;
  final int lowStockMedicines;
  final int pendingAppointments;

  DashboardSummary({
    required this.totalUsers,
    required this.totalDoctors,
    required this.totalMedicines,
    required this.totalAppointments,
    required this.totalRevenue,
    required this.activeUsers,
    required this.lowStockMedicines,
    required this.pendingAppointments,
  });
}

class ChartData {
  final String label;
  final double value;
  final String? color;

  ChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class TimeSeriesData {
  final DateTime date;
  final double value;
  final String? category;

  TimeSeriesData({
    required this.date,
    required this.value,
    this.category,
  });
}