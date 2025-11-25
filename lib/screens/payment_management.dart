import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentManagement extends StatefulWidget {
  const PaymentManagement({super.key});

  @override
  State<PaymentManagement> createState() => _PaymentManagementState();
}

class _PaymentManagementState extends State<PaymentManagement> {
  late Future<List<Payment>> _paymentsFuture;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _paymentsFuture = PaymentService.getAllPayments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshPayments() {
    setState(() {
      _paymentsFuture = PaymentService.getAllPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Management'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by user or intent ID...',
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
            child: FutureBuilder<List<Payment>>(
              future: _paymentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text('Error loading payments: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _refreshPayments, child: const Text('Retry')),
                      ],
                    ),
                  );
                }

                final payments = snapshot.data ?? [];
                final filtered = payments.where((p) {
                  final searchStr = '${p.userUsername ?? ''}${p.userEmail ?? ''}${p.paymentIntentId}'.toLowerCase();
                  return searchStr.contains(_searchQuery);
                }).toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No payments found', style: TextStyle(fontSize: 18)));
                }

                return RefreshIndicator(
                  onRefresh: () async => _refreshPayments(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(child: Text(p.currency.toUpperCase())),
                          title: Text('${p.amount.toStringAsFixed(2)} ${p.currency} • ${p.status}'),
                          subtitle: Text(
                            'User: ${p.userUsername ?? p.userEmail ?? 'Unknown'}\n'
                            'Intent: ${p.paymentIntentId}\n'
                            'Address: ${(p.fullAddress ?? p.address ?? 'N/A').toString()}'
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${p.createdAt.toLocal()}'.split('.').first),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Payment'),
                                      content: const Text('Are you sure you want to delete this payment?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                        TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    try {
                                      await PaymentService.deletePayment(p.id);
                                      _refreshPayments();
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Payment deleted'), backgroundColor: Colors.green),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
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
