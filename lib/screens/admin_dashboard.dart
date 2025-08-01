import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import '../utils/responsive.dart';
import '../widgets/sidebarx_widget.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/dashboard_card.dart';
import '../screens/analytics_dashboard.dart';
import '../screens/admin_management_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: false);
  Key _statsKey = UniqueKey();

  Future<void> _navigate(String route) async {
    await Navigator.pushNamed(context, route);
    if (mounted) {
      setState(() {
        _statsKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: Responsive.isMobile(context)
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              'A',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Responsive.isMobile(context) ? SidebarXWidget(controller: _controller) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context))
            SidebarXWidget(controller: _controller),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Admin',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  DashboardStats(key: _statsKey),
                  const SizedBox(height: 32),
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: Responsive.isDesktop(context)
                          ? 4
                          : Responsive.isTablet(context)
                              ? 2
                              : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: Responsive.isDesktop(context) ? 1.5 : 1.8,
                      children: [
                        DashboardCard(
                          title: 'User Management',
                          icon: Icons.people,
                          color: Colors.blue,
                          onTap: () => _navigate('/users'),
                        ),
                        DashboardCard(
                          title: 'Doctor Management',
                          icon: Icons.medical_services,
                          color: Colors.green,
                          onTap: () => _navigate('/doctors'),
                        ),
                        DashboardCard(
                          title: 'Medicine Management',
                          icon: Icons.medication,
                          color: Colors.orange,
                          onTap: () => _navigate('/medicines'),
                        ),
                        DashboardCard(
                          title: 'Analytics Dashboard',
                          icon: Icons.analytics,
                          color: Colors.purple,
                          onTap: () => _navigate('/analytics'),
                        ),
                        DashboardCard(
                          title: 'Admin Management',
                          icon: Icons.admin_panel_settings,
                          color: Colors.red,
                          onTap: () => _navigate('/admin-management'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}