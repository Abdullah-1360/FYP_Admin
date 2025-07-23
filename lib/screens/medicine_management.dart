import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../services/admin_service.dart';
import '../widgets/medicine_list_item.dart';
import '../widgets/add_medicine_dialog.dart';

class MedicineManagement extends StatefulWidget {
  const MedicineManagement({super.key});

  @override
  State<MedicineManagement> createState() => _MedicineManagementState();
}

class _MedicineManagementState extends State<MedicineManagement> {
  late Future<List<Medicine>> _medicinesFuture;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _medicinesFuture = _fetchMedicinesAndCategories();
  }

  Future<List<Medicine>> _fetchMedicinesAndCategories() async {
    final medicines = await AdminService.getAllMedicines();
    final categories = medicines.map((m) => m.category).toSet().toList();
    setState(() {
      _categories = ['All', ...categories];
    });
    return medicines;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshMedicines() {
    setState(() {
      _medicinesFuture = _fetchMedicinesAndCategories();
    });
  }

  Future<void> _showAddMedicineDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AddMedicineDialog(),
    );

    if (result == true) {
      _refreshMedicines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Management'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMedicineDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search medicines...',
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
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(category),
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : 'All';
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Medicine>>(
              future: _medicinesFuture,
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
                          'Error loading medicines: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshMedicines,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final medicines = snapshot.data!;
                final filteredMedicines = medicines.where((medicine) {
                  final matchesSearch = medicine.name.toLowerCase().contains(_searchQuery) ||
                      medicine.description.toLowerCase().contains(_searchQuery);
                  final matchesCategory =
                      _selectedCategory == 'All' || medicine.category == _selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredMedicines.isEmpty) {
                  return const Center(
                    child: Text(
                      'No medicines found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _refreshMedicines();
                  },
                  child: ListView.builder(
                    itemCount: filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = filteredMedicines[index];
                      return MedicineListItem(
                        medicine: medicine,
                        onEdit: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => AddMedicineDialog(
                              medicine: medicine,
                            ),
                          );

                          if (result == true) {
                            _refreshMedicines();
                          }
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Medicine'),
                              content: Text(
                                'Are you sure you want to delete ${medicine.name}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await AdminService.deleteMedicine(medicine.id);
                              _refreshMedicines();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Medicine deleted successfully'),
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