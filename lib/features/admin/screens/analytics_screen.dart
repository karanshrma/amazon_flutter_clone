import 'package:amazon_flutter_clone/features/admin/services/admin_service.dart';
import 'package:amazon_flutter_clone/features/admin/widgets/category_products_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../models/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminService adminService = AdminService();
  int? totalSales;
  List<Sales>? earnings;

  final List<Sales> dummyEarnings = [
    Sales('Mobiles', 150),
    Sales('Laptops', 250),
    Sales('Clothes', 200),
    Sales('Shoes', 120),
    Sales('Books', 80),
  ];

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  void getEarnings() async {
    //var earningData = await adminService.getEarnings(context);
    totalSales = dummyEarnings.fold(0, (sum, item) => sum! + item.earning);
    earnings = dummyEarnings;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '\$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    barGroups: dummyEarnings.asMap().entries.map((entry) {
                      int index = entry.key;
                      Sales sales = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(toY: sales.earning.toDouble(), color: Colors.blue),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index < dummyEarnings.length) {
                              return Text(dummyEarnings[index].label, style: const TextStyle(fontSize: 10));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                  ),
                )
              )
            ],
          );
  }
}
