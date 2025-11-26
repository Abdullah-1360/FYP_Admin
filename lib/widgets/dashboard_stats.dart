import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/responsive.dart';
import '../services/admin_service.dart';
import '../services/analytics_service.dart';

class DashboardStats extends StatefulWidget {
  const DashboardStats({super.key});

  @override
  State<DashboardStats> createState() => _DashboardStatsState();
}

class _DashboardStatsState extends State<DashboardStats> {
  int _totalUsers = 0;
  int _activeDoctors = 0;
  int _medicineStock = 0;
  double _totalRevenue = 0.0;
  bool _loading = true;
  Timer? _revenueTimer;

  @override
  void initState() {
    super.initState();
    _fetchStats();
    _fetchRevenue();
    _startRevenuePolling();
  }

  Future<void> _fetchStats() async {
    try {
      final users = await AdminService.getAllUsers();
      final doctors = await AdminService.getAllDoctors();
      final medicines = await AdminService.getAllMedicines();

      if (!mounted) return;

      setState(() {
        _totalUsers = users.length;
        _activeDoctors = doctors.length;
        _medicineStock = medicines.length;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchRevenue() async {
    try {
      final summary = await AnalyticsService.getDashboardSummary();
      if (!mounted) return;
      setState(() {
        _totalRevenue = summary.totalRevenue;
      });
    } catch (_) {
      if (!mounted) return;
    }
  }

  void _startRevenuePolling() {
    _revenueTimer?.cancel();
    _revenueTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchRevenue();
    });
  }

  @override
  void dispose() {
    _revenueTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Responsive.isDesktop(context)
          ? 4
          : Responsive.isTablet(context)
              ? 2
              : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: Responsive.isDesktop(context) ? 1.6 : 1.4,
      children: [
        _StatCard(
          title: 'Total Users',
          value: _totalUsers.toString(),
          icon: Icons.people,
          color: Colors.blue,
          increase: '',
        ),
        _StatCard(
          title: 'Active Doctors',
          value: _activeDoctors.toString(),
          icon: Icons.medical_services,
          color: Colors.green,
          increase: '',
        ),
        _StatCard(
          title: 'Medicines',
          value: _medicineStock.toString(),
          icon: Icons.medication,
          color: Colors.orange,
          increase: '',
        ),
        _StatCard(
          title: 'Total Revenue',
          value: '\u0024${_totalRevenue.toStringAsFixed(0)}',
          icon: Icons.attach_money,
          color: Colors.purple,
          increase: '',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String increase;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.increase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                Icon(
                  icon,
                  color: color.withOpacity(0.8),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_upward, color: Colors.green[700], size: 16),
                  if (increase.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(increase, style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
