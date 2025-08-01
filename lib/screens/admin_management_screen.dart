import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/admin_service.dart';
import '../models/user_model.dart';
import '../models/doctor_model.dart';
import '../models/appointment.dart';
import '../models/medicine_model.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.medical_services), text: 'Doctors'),
            Tab(icon: Icon(Icons.schedule), text: 'Appointments'),
            Tab(icon: Icon(Icons.medication), text: 'Medicines'),
            Tab(icon: Icon(Icons.analytics), text: 'Sales'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UserManagementTab(),
          DoctorManagementTab(),
          AppointmentManagementTab(),
          MedicineManagementTab(),
          SalesManagementTab(),
        ],
      ),
    );
  }
}

// User Management Tab
class UserManagementTab extends StatefulWidget {
  const UserManagementTab({super.key});

  @override
  State<UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<UserManagementTab> {
  final AdminService _adminService = AdminService();
  List<AdminUser> _users = [];
  List<AdminUser> _filteredUsers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await AdminService.getAllUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load users: $e');
    }
  }

  void _filterUsers() {
    setState(() {
      _filteredUsers = _users.where((user) {
        final matchesSearch = user.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.email.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Active' && !user.isBlocked) ||
            (_selectedFilter == 'Blocked' && user.isBlocked);
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  Future<void> _toggleUserStatus(AdminUser user) async {
    try {
      await _adminService.toggleUserStatus(user.id);
      await _loadUsers();
      _showSuccessSnackBar('User status updated successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to update user status: $e');
    }
  }

  Future<void> _resetUserPassword(AdminUser user) async {
    final confirmed = await _showConfirmDialog(
      'Reset Password',
      'Are you sure you want to reset password for ${user.username}?',
    );
    if (confirmed) {
      try {
        await _adminService.resetUserPassword(user.id);
        _showSuccessSnackBar('Password reset email sent to ${user.email}');
      } catch (e) {
        _showErrorSnackBar('Failed to reset password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterUsers();
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedFilter,
                items: ['All', 'Active', 'Blocked']
                    .map((filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedFilter = value!);
                  _filterUsers();
                },
              ),
            ],
          ),
        ),
        
        // Users List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredUsers.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: !user.isBlocked
                                  ? Colors.green
                                  : Colors.red,
                              child: Text(
                                user.username.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(user.username),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.email),
                                Text(
                                  'Joined: ${DateFormat('MMM dd, yyyy').format(user.createdAt)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) {
                                switch (action) {
                                  case 'toggle':
                                    _toggleUserStatus(user);
                                    break;
                                  case 'reset':
                                    _resetUserPassword(user);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Text(
                                    !user.isBlocked ? 'Block User' : 'Activate User',
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'reset',
                                  child: Text('Reset Password'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// Doctor Management Tab
class DoctorManagementTab extends StatefulWidget {
  const DoctorManagementTab({super.key});

  @override
  State<DoctorManagementTab> createState() => _DoctorManagementTabState();
}

class _DoctorManagementTabState extends State<DoctorManagementTab> {
  final AdminService _adminService = AdminService();
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedSpecialization = 'All';

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      final doctors = await AdminService.getAllDoctors();
      setState(() {
        _doctors = doctors;
        _filteredDoctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load doctors: $e');
    }
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        final matchesSearch = doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            doctor.specialization.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesSpecialization = _selectedSpecialization == 'All' ||
            doctor.specialization == _selectedSpecialization;
        return matchesSearch && matchesSpecialization;
      }).toList();
    });
  }

  void _viewDoctorDetails(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dr. ${doctor.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialization: ${doctor.specialization}'),
            Text('Experience: ${doctor.experience} years'),
            Text('Average Rating: ${doctor.averageRating.toStringAsFixed(1)}/5'),
            Text('Total Appointments: ${doctor.appointments.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final specializations = ['All', ...{..._doctors.map((d) => d.specialization)}];

    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search doctors...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterDoctors();
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedSpecialization,
                items: specializations
                    .map((spec) => DropdownMenuItem(
                          value: spec,
                          child: Text(spec),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedSpecialization = value!);
                  _filterDoctors();
                },
              ),
            ],
          ),
        ),
        
        // Doctors List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredDoctors.isEmpty
                  ? const Center(child: Text('No doctors found'))
                  : ListView.builder(
                      itemCount: _filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = _filteredDoctors[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                doctor.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text('Dr. ${doctor.name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doctor.specialization),
                                Text('Rating: ${doctor.averageRating.toStringAsFixed(1)}/5'),
                                Text(
                                  'Experience: ${doctor.experience} years',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) {
                                switch (action) {
                                  case 'view':
                                    _viewDoctorDetails(doctor);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Text('View Details'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Appointment Management Tab
class AppointmentManagementTab extends StatefulWidget {
  const AppointmentManagementTab({super.key});

  @override
  State<AppointmentManagementTab> createState() => _AppointmentManagementTabState();
}

class _AppointmentManagementTabState extends State<AppointmentManagementTab> {
  final AdminService _adminService = AdminService();
  List<Appointment> _appointments = [];
  List<Appointment> _filteredAppointments = [];
  bool _isLoading = true;
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final appointmentsData = await _adminService.getAllAppointments();
      final appointments = appointmentsData.map((data) => Appointment.fromJson(data)).toList();
      setState(() {
        _appointments = appointments;
        _filteredAppointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load appointments: $e');
    }
  }

  void _filterAppointments() {
    setState(() {
      _filteredAppointments = _appointments.where((appointment) {
        return _selectedStatus == 'All' || appointment.status == _selectedStatus;
      }).toList();
    });
  }

  Future<void> _updateAppointmentStatus(Appointment appointment, String newStatus) async {
    try {
      await _adminService.updateAppointmentStatus(appointment.id, newStatus);
      await _loadAppointments();
      _showSuccessSnackBar('Appointment status updated successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to update appointment status: $e');
    }
  }

  Future<void> _rescheduleAppointment(Appointment appointment) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: appointment.appointmentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (newDate != null) {
      final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(appointment.appointmentDate),
      );
      
      if (newTime != null) {
        final newDateTime = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
          newTime.hour,
          newTime.minute,
        );
        
        try {
          await _adminService.rescheduleAppointment(appointment.id, newDateTime);
          await _loadAppointments();
          _showSuccessSnackBar('Appointment rescheduled successfully');
        } catch (e) {
          _showErrorSnackBar('Failed to reschedule appointment: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text('Filter by status: '),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedStatus,
                items: ['All', 'Pending', 'Confirmed', 'Approved', 'Completed', 'Cancelled']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                  _filterAppointments();
                },
              ),
            ],
          ),
        ),
        
        // Appointments List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredAppointments.isEmpty
                  ? const Center(child: Text('No appointments found'))
                  : ListView.builder(
                      itemCount: _filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = _filteredAppointments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(appointment.status),
                              child: Icon(
                                Icons.schedule,
                                color: Colors.white,
                              ),
                            ),
                            title: Text('${appointment.patientName} - Dr. ${appointment.doctorName}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('MMM dd, yyyy - hh:mm a')
                                      .format(appointment.appointmentDate),
                                ),
                                Text(
                                  'Status: ${appointment.status}',
                                  style: TextStyle(
                                    color: _getStatusColor(appointment.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) {
                                switch (action) {
                                  case 'confirm':
                                    _updateAppointmentStatus(appointment, 'Confirmed');
                                    break;
                                  case 'approve':
                                    _updateAppointmentStatus(appointment, 'Approved');
                                    break;
                                  case 'complete':
                                    _updateAppointmentStatus(appointment, 'Completed');
                                    break;
                                  case 'cancel':
                                    _updateAppointmentStatus(appointment, 'Cancelled');
                                    break;
                                  case 'reschedule':
                                    _rescheduleAppointment(appointment);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                if (appointment.status == 'Pending') ...[
                                  const PopupMenuItem(
                                    value: 'confirm',
                                    child: Text('Confirm'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'approve',
                                    child: Text('Approve'),
                                  ),
                                ],
                                if (appointment.status == 'Confirmed' || appointment.status == 'Approved')
                                  const PopupMenuItem(
                                    value: 'complete',
                                    child: Text('Mark Complete'),
                                  ),
                                const PopupMenuItem(
                                  value: 'reschedule',
                                  child: Text('Reschedule'),
                                ),
                                if (appointment.status != 'Cancelled')
                                  const PopupMenuItem(
                                    value: 'cancel',
                                    child: Text('Cancel'),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'Approved':
        return Colors.green;
      case 'Completed':
        return Colors.teal;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Medicine Management Tab
class MedicineManagementTab extends StatefulWidget {
  const MedicineManagementTab({super.key});

  @override
  State<MedicineManagementTab> createState() => _MedicineManagementTabState();
}

class _MedicineManagementTabState extends State<MedicineManagementTab> {
  final AdminService _adminService = AdminService();
  List<Medicine> _medicines = [];
  List<Medicine> _filteredMedicines = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    try {
      final medicines = await AdminService.getAllMedicines();
      setState(() {
        _medicines = medicines;
        _filteredMedicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load medicines: $e');
    }
  }

  void _filterMedicines() {
    setState(() {
      _filteredMedicines = _medicines.where((medicine) {
        final matchesSearch = medicine.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            medicine.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...{..._medicines.map((m) => m.category)}];

    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search medicines...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterMedicines();
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                  _filterMedicines();
                },
              ),
            ],
          ),
        ),
        
        // Medicines List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredMedicines.isEmpty
                  ? const Center(child: Text('No medicines found'))
                  : ListView.builder(
                      itemCount: _filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = _filteredMedicines[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: medicine.stock > 10
                                  ? Colors.green
                                  : medicine.stock > 0
                                      ? Colors.orange
                                      : Colors.red,
                              child: const Icon(
                                Icons.medication,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(medicine.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${medicine.category}'),
                                Text('Price: \$${medicine.price.toStringAsFixed(2)}'),
                                Text(
                                  'Stock: ${medicine.stock}',
                                  style: TextStyle(
                                    color: medicine.stock > 10
                                        ? Colors.green
                                        : medicine.stock > 0
                                            ? Colors.orange
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: medicine.stock <= 10
                                ? Icon(
                                    Icons.warning,
                                    color: medicine.stock > 0 ? Colors.orange : Colors.red,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Sales Management Tab
class SalesManagementTab extends StatefulWidget {
  const SalesManagementTab({super.key});

  @override
  State<SalesManagementTab> createState() => _SalesManagementTabState();
}

class _SalesManagementTabState extends State<SalesManagementTab> {
  final AdminService _adminService = AdminService();
  List<dynamic> _sales = [];
  bool _isLoading = true;
  double _totalRevenue = 0;
  int _totalOrders = 0;

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    try {
      final sales = await _adminService.getSalesData();
      setState(() {
        _sales = sales;
        _totalRevenue = sales.fold(0.0, (sum, sale) => sum + (sale['total'] ?? 0.0));
        _totalOrders = sales.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load sales data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Cards
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.attach_money, size: 32, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(
                          '\$${_totalRevenue.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Revenue'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.shopping_cart, size: 32, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(
                          _totalOrders.toString(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Orders'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Sales List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _sales.isEmpty
                  ? const Center(child: Text('No sales data found'))
                  : ListView.builder(
                      itemCount: _sales.length,
                      itemBuilder: (context, index) {
                        final sale = _sales[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.receipt,
                                color: Colors.white,
                              ),
                            ),
                            title: Text('Order #${sale['id']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer: ${sale['customerName'] ?? 'N/A'}'),
                                Text(
                                  'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(sale['createdAt']))}',
                                ),
                                Text('Status: ${sale['status'] ?? 'N/A'}'),
                              ],
                            ),
                            trailing: Text(
                              '\$${(sale['total'] ?? 0.0).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}