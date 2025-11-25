import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  // User statistics
  int _totalUsers = 0;
  int _activeUsers = 0;
  int _newUsers = 0;
  bool _isLoadingUsers = false;
  String? _userError;

  // Doctor statistics
  int _totalDoctors = 0;
  int _activeDoctors = 0;
  int _newDoctors = 0;
  bool _isLoadingDoctors = false;
  String? _doctorError;

  // Medicine statistics
  int _totalMedicines = 0;
  int _availableMedicines = 0;
  int _lowStockMedicines = 0;
  bool _isLoadingMedicines = false;
  String? _medicineError;

  // Getters for user statistics
  int get totalUsers => _totalUsers;
  int get activeUsers => _activeUsers;
  int get newUsers => _newUsers;
  bool get isLoadingUsers => _isLoadingUsers;
  String? get userError => _userError;

  // Getters for doctor statistics
  int get totalDoctors => _totalDoctors;
  int get activeDoctors => _activeDoctors;
  int get newDoctors => _newDoctors;
  bool get isLoadingDoctors => _isLoadingDoctors;
  String? get doctorError => _doctorError;

  // Getters for medicine statistics
  int get totalMedicines => _totalMedicines;
  int get availableMedicines => _availableMedicines;
  int get lowStockMedicines => _lowStockMedicines;
  bool get isLoadingMedicines => _isLoadingMedicines;
  String? get medicineError => _medicineError;

  // Initialize with dummy data for demonstration
  DataProvider() {
    fetchUserStatistics();
    fetchDoctorStatistics();
    fetchMedicineStatistics();
  }

  // Fetch user statistics
  Future<void> fetchUserStatistics() async {
    _isLoadingUsers = true;
    _userError = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, you would make an API call here
      _totalUsers = 1250;
      _activeUsers = 850;
      _newUsers = 120;
      _isLoadingUsers = false;
    } catch (e) {
      _userError = 'Failed to load user statistics';
      _isLoadingUsers = false;
    }
    
    notifyListeners();
  }

  // Fetch doctor statistics
  Future<void> fetchDoctorStatistics() async {
    _isLoadingDoctors = true;
    _doctorError = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, you would make an API call here
      _totalDoctors = 75;
      _activeDoctors = 60;
      _newDoctors = 8;
      _isLoadingDoctors = false;
    } catch (e) {
      _doctorError = 'Failed to load doctor statistics';
      _isLoadingDoctors = false;
    }
    
    notifyListeners();
  }

  // Fetch medicine statistics
  Future<void> fetchMedicineStatistics() async {
    _isLoadingMedicines = true;
    _medicineError = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, you would make an API call here
      _totalMedicines = 320;
      _availableMedicines = 290;
      _lowStockMedicines = 30;
      _isLoadingMedicines = false;
    } catch (e) {
      _medicineError = 'Failed to load medicine statistics';
      _isLoadingMedicines = false;
    }
    
    notifyListeners();
  }

  // Refresh all statistics
  Future<void> refreshAllStatistics() async {
    await Future.wait([
      fetchUserStatistics(),
      fetchDoctorStatistics(),
      fetchMedicineStatistics(),
    ]);
  }
}