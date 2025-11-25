import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import '../services/auth_service.dart';

class SidebarXWidget extends StatefulWidget {
  final SidebarXController controller;

  const SidebarXWidget({super.key, required this.controller});

  @override
  State<SidebarXWidget> createState() => _SidebarXWidgetState();
}

class _SidebarXWidgetState extends State<SidebarXWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          widget.controller.setExtended(true);
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          widget.controller.setExtended(false);
        });
      },
      child: SidebarX(
      controller: widget.controller,
      theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: _isHovered
                ? const Border(
                    right: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.1),
        textStyle: TextStyle(
          color: Colors.grey[700],
          fontSize: 16,
        ),
        selectedTextStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.transparent),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.37),
          ),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[700],
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: const Border(
              right: BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: extended ? 25 : 20,
                  child: const Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (extended) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Admin',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'admin@aiplant.com',
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
          onTap: () => _navigateToRoute(context, '/dashboard'),
        ),
        SidebarXItem(
          icon: Icons.analytics,
          label: 'Analytics',
          onTap: () => _navigateToRoute(context, '/analytics'),
        ),
        SidebarXItem(
          icon: Icons.admin_panel_settings,
          label: 'Admin Management',
          onTap: () => _navigateToRoute(context, '/admin-management'),
        ),
        SidebarXItem(
          icon: Icons.people,
          label: 'Users',
          onTap: () => _navigateToRoute(context, '/users'),
        ),
        SidebarXItem(
          icon: Icons.medical_services,
          label: 'Doctors',
          onTap: () => _navigateToRoute(context, '/doctors'),
        ),
        SidebarXItem(
          icon: Icons.medication,
          label: 'Medicines',
          onTap: () => _navigateToRoute(context, '/medicines'),
        ),
        SidebarXItem(
          icon: Icons.payments,
          label: 'Payments',
          onTap: () => _navigateToRoute(context, '/payments'),
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () => _navigateToRoute(context, '/settings'),
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Logout',
          onTap: () => _handleLogout(context),
        ),
      ],
    ));
  }

  void _navigateToRoute(BuildContext context, String route) {
    if (route == '/dashboard') {
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
