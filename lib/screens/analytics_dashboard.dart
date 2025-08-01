import 'package:flutter/material.dart';
import '../widgets/analytics_charts.dart';
import '../services/analytics_service.dart';
import '../models/analytics_models.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  final AnalyticsService _analyticsService = AnalyticsService();
  DashboardSummary? _dashboardSummary;
  UserAnalytics? _userAnalytics;
  DoctorAnalytics? _doctorAnalytics;
  MedicineAnalytics? _medicineAnalytics;
  AppointmentAnalytics? _appointmentAnalytics;
  RevenueAnalytics? _revenueAnalytics;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final results = await Future.wait([
        AnalyticsService.getDashboardSummary(),
        AnalyticsService.getUserAnalytics(),
        AnalyticsService.getDoctorAnalytics(),
        AnalyticsService.getMedicineAnalytics(),
        AnalyticsService.getAppointmentAnalytics(),
        AnalyticsService.getRevenueAnalytics(),
      ]);

      setState(() {
        _dashboardSummary = results[0] as DashboardSummary;
        _userAnalytics = results[1] as UserAnalytics;
        _doctorAnalytics = results[2] as DoctorAnalytics;
        _medicineAnalytics = results[3] as MedicineAnalytics;
        _appointmentAnalytics = results[4] as AppointmentAnalytics;
        _revenueAnalytics = results[5] as RevenueAnalytics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalyticsData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading analytics data',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAnalyticsData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards
                      _buildSummaryCards(),
                      const SizedBox(height: 24),
                      
                      // Charts Grid
                      _buildChartsGrid(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSummaryCards() {
    if (_dashboardSummary == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: _getGridCrossAxisCount(context),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildSummaryCard(
              'Total Users',
              _dashboardSummary!.totalUsers.toString(),
              Icons.people,
              Colors.blue,
            ),
            _buildSummaryCard(
              'Total Doctors',
              _dashboardSummary!.totalDoctors.toString(),
              Icons.medical_services,
              Colors.green,
            ),
            _buildSummaryCard(
              'Total Medicines',
              _dashboardSummary!.totalMedicines.toString(),
              Icons.medication,
              Colors.orange,
            ),
            _buildSummaryCard(
              'Total Revenue',
              '\$${_dashboardSummary!.totalRevenue.toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.purple,
            ),
            _buildSummaryCard(
              'Pending Appointments',
              _dashboardSummary!.pendingAppointments.toString(),
              Icons.schedule,
              Colors.red,
            ),
            _buildSummaryCard(
              'Active Users',
              _dashboardSummary!.activeUsers.toString(),
              Icons.person,
              Colors.teal,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics Charts',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // User Analytics
        if (_userAnalytics != null) ...[
          Row(
            children: [
              Expanded(
                child: UserRegistrationChart(
                  monthlyData: _userAnalytics!.monthlyRegistrations,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: UserStatusChart(
                  activeUsers: _userAnalytics!.activeUsers,
                  blockedUsers: _userAnalytics!.blockedUsers,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        
        // Doctor and Medicine Analytics
        if (_doctorAnalytics != null && _medicineAnalytics != null) ...[
          Row(
            children: [
              Expanded(
                child: DoctorSpecializationChart(
                  specializationData: _doctorAnalytics!.doctorsBySpecialization,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MedicineCategoryChart(
                  categoryData: _medicineAnalytics!.medicinesByCategory,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        
        // Revenue and Inventory
        if (_revenueAnalytics != null && _medicineAnalytics != null) ...[
          Row(
            children: [
              Expanded(
                child: RevenueChart(
                  monthlyRevenue: _revenueAnalytics!.monthlyRevenue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InventoryStatusChart(
                  totalMedicines: _medicineAnalytics!.totalMedicines,
                  lowStockMedicines: _medicineAnalytics!.lowStockMedicines,
                  outOfStockMedicines: _medicineAnalytics!.outOfStockMedicines,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  int _getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }
}