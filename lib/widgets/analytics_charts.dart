import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/analytics_models.dart';

class UserRegistrationChart extends StatelessWidget {
  final Map<String, int> monthlyData;
  
  const UserRegistrationChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Registrations Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final keys = monthlyData.keys.toList()..sort();
                          if (value.toInt() >= 0 && value.toInt() < keys.length) {
                            final monthKey = keys[value.toInt()];
                            final parts = monthKey.split('-');
                            return Text('${parts[1]}/${parts[0].substring(2)}');
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSpots(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getSpots() {
    final sortedKeys = monthlyData.keys.toList()..sort();
    return sortedKeys.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), monthlyData[entry.value]!.toDouble());
    }).toList();
  }
}

class DoctorSpecializationChart extends StatelessWidget {
  final Map<String, int> specializationData;
  
  const DoctorSpecializationChart({super.key, required this.specializationData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Specializations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _getSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
    
    return specializationData.entries.map((entry) {
      final index = specializationData.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.value}',
        color: colors[index % colors.length],
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
    
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: specializationData.entries.map((entry) {
        final index = specializationData.keys.toList().indexOf(entry.key);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(entry.key, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}

class MedicineCategoryChart extends StatelessWidget {
  final Map<String, int> categoryData;
  
  const MedicineCategoryChart({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: categoryData.values.isNotEmpty 
                      ? categoryData.values.reduce((a, b) => a > b ? a : b).toDouble() + 5
                      : 10,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final keys = categoryData.keys.toList();
                          if (value.toInt() >= 0 && value.toInt() < keys.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                keys[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _getBarGroups(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return categoryData.entries.map((entry) {
      final index = categoryData.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }
}

class RevenueChart extends StatelessWidget {
  final Map<String, double> monthlyRevenue;
  
  const RevenueChart({super.key, required this.monthlyRevenue});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Revenue Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${(value / 1000).toStringAsFixed(0)}K',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final keys = monthlyRevenue.keys.toList()..sort();
                          if (value.toInt() >= 0 && value.toInt() < keys.length) {
                            final monthKey = keys[value.toInt()];
                            final parts = monthKey.split('-');
                            return Text('${parts[1]}/${parts[0].substring(2)}');
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getRevenueSpots(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getRevenueSpots() {
    final sortedKeys = monthlyRevenue.keys.toList()..sort();
    return sortedKeys.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), monthlyRevenue[entry.value]!);
    }).toList();
  }
}

class UserStatusChart extends StatelessWidget {
  final int activeUsers;
  final int blockedUsers;
  
  const UserStatusChart({
    super.key,
    required this.activeUsers,
    required this.blockedUsers,
  });

  @override
  Widget build(BuildContext context) {
    final total = activeUsers + blockedUsers;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Status Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: activeUsers.toDouble(),
                      title: '${((activeUsers / total) * 100).toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: blockedUsers.toDouble(),
                      title: '${((blockedUsers / total) * 100).toStringAsFixed(1)}%',
                      color: Colors.red,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem('Active', activeUsers, Colors.green),
                _buildStatusItem('Blocked', blockedUsers, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text('$label: $count'),
      ],
    );
  }
}

class InventoryStatusChart extends StatelessWidget {
  final int totalMedicines;
  final int lowStockMedicines;
  final int outOfStockMedicines;
  
  const InventoryStatusChart({
    super.key,
    required this.totalMedicines,
    required this.lowStockMedicines,
    required this.outOfStockMedicines,
  });

  @override
  Widget build(BuildContext context) {
    final inStockMedicines = totalMedicines - lowStockMedicines - outOfStockMedicines;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: totalMedicines.toDouble() + 5,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('In Stock');
                            case 1:
                              return const Text('Low Stock');
                            case 2:
                              return const Text('Out of Stock');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: inStockMedicines.toDouble(),
                          color: Colors.green,
                          width: 40,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: lowStockMedicines.toDouble(),
                          color: Colors.orange,
                          width: 40,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: outOfStockMedicines.toDouble(),
                          color: Colors.red,
                          width: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}