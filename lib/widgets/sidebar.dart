import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: true,
                  onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                ),
                _SidebarItem(
                  icon: Icons.people,
                  title: 'Users',
                  onTap: () => Navigator.pushNamed(context, '/users'),
                ),
                _SidebarItem(
                  icon: Icons.medical_services,
                  title: 'Doctors',
                  onTap: () => Navigator.pushNamed(context, '/doctors'),
                ),
                _SidebarItem(
                  icon: Icons.medication,
                  title: 'Medicines',
                  onTap: () => Navigator.pushNamed(context, '/medicines'),
                ),
                _SidebarItem(
                  icon: Icons.analytics,
                  title: 'Statistics',
                  onTap: () => Navigator.pushNamed(context, '/stats'),
                ),
                const Divider(),
                _SidebarItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                _SidebarItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async {
                    await AuthService.logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[700],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
    );
  }
} 