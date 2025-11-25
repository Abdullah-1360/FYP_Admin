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

  Future<void> _refreshPayments() async {
    final future = PaymentService.getAllPayments();
    setState(() {
      _paymentsFuture = future;
    });
    await future;
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
                        ElevatedButton(onPressed: () => _refreshPayments(), child: const Text('Retry')),
                      ],
                    ),
                  );
                }

                final payments = snapshot.data ?? [];
                final filtered = payments.where((p) {
                  final searchStr = '${p.userUsername ?? ''}${p.userEmail ?? ''}${p.userName ?? ''}${p.paymentIntentId}'.toLowerCase();
                  return searchStr.contains(_searchQuery);
                }).toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No payments found', style: TextStyle(fontSize: 18)));
                }

                return RefreshIndicator(
                  onRefresh: () => _refreshPayments(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(child: Text(p.currency.toUpperCase())),
                                title: Text('${p.amount.toStringAsFixed(2)} ${p.currency} • ${p.status}'),
                                subtitle: Text(
                                  'User: ${p.userName ?? p.userUsername ?? p.userEmail ?? 'Unknown'}\n'
                                  'Intent: ${p.paymentIntentId}\n'
                                  'Address: ${(p.fullAddress ?? p.address ?? 'N/A').toString()}'
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${p.createdAt.toLocal()}'.split('.').first),
                                    const SizedBox(width: 12),
                                    PopupMenuButton<String>(
                                      onSelected: (value) async {
                                        try {
                                          await PaymentService.updatePaymentStatus(p.id, value);
                                          await _refreshPayments();
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Status updated to $value'), backgroundColor: Colors.green),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                                            );
                                          }
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(value: 'pending', child: Text('Mark Pending')),
                                        PopupMenuItem(value: 'succeeded', child: Text('Mark Succeeded')),
                                        PopupMenuItem(value: 'failed', child: Text('Mark Failed')),
                                        PopupMenuItem(value: 'cancelled', child: Text('Mark Cancelled')),
                                      ],
                                    ),
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
                                            await _refreshPayments();
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
                              if (p.items.isNotEmpty) ...[
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text('Items (${p.items.length})'),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: p.items.length,
                                  itemBuilder: (context, idx) {
                                    final it = p.items[idx];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(it.medicineName.isEmpty ? 'Item' : it.medicineName)),
                                          Text('x${it.quantity}'),
                                          Text('${it.price.toStringAsFixed(2)} ${p.currency.toUpperCase()}'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
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
