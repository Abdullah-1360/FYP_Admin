import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/admin_service.dart';
import '../widgets/user_card.dart';
import '../utils/responsive.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  late Future<List<AdminUser>> _usersFuture;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _usersFuture = AdminService.getAllUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = AdminService.getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AdminUser>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading users: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshUsers,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final users = snapshot.data!;
                final filteredUsers = users.where((user) {
                  final searchStr = user.username.toLowerCase() +
                      user.email.toLowerCase();
                  return searchStr.contains(_searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _refreshUsers(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isDesktop(context)
                          ? 4
                          : Responsive.isTablet(context)
                              ? 3
                              : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return UserCard(
                        user: user,
                        onBlockToggle: (bool blocked) async {
                          try {
                            if (blocked) {
                              await AdminService.blockUser(user.id);
                            } else {
                              await AdminService.unblockUser(user.id);
                            }
                            _refreshUsers();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(blocked
                                      ? 'User blocked successfully'
                                      : 'User unblocked successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete User'),
                              content: Text('Are you sure you want to delete ${user.username}?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await AdminService.deleteUser(user.id);
                              _refreshUsers();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted successfully'), backgroundColor: Colors.green));
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 