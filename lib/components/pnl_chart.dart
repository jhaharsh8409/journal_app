import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PnlChart extends StatelessWidget {
  final List<QueryDocumentSnapshot> trades;

  const PnlChart({super.key, required this.trades});

  @override
  Widget build(BuildContext context) {
    // Reverse the list to show chronological order
    final reversedTrades = trades.reversed.toList();

    List<FlSpot> spots = [];
    double cumulativePnl = 0;
    double minY = 0;
    double maxY = 0;

    for (int i = 0; i < reversedTrades.length; i++) {
      final trade = reversedTrades[i];
      final amount = trade['amount'] as double;
      final outcome = trade['tradeOutcome'] as String;

      if (outcome == 'Profit') {
        cumulativePnl += amount;
      } else {
        cumulativePnl -= amount;
      }

      if (cumulativePnl < minY) {
        minY = cumulativePnl;
      }
      if (cumulativePnl > maxY) {
        maxY = cumulativePnl;
      }

      spots.add(FlSpot(i.toDouble(), cumulativePnl));
    }

    // Add some padding to min and max Y
    final padding = (maxY - minY).abs() * 0.2;
    minY -= padding;
    maxY += padding;

    // Handle case where minY and maxY are the same or there's only one trade
    if (spots.length <= 1 || minY == maxY) {
      minY -= 100; // Default padding
      maxY += 100;
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: const Color(0xff232d3b),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final flSpot = barSpot.bar.spots[barSpot.spotIndex];
                      return LineTooltipItem(
                        '\$${flSpot.y.toStringAsFixed(2)}',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: (maxY - minY) / 4,
                verticalInterval: (reversedTrades.length -1) / 4,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Color(0xff37434d),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return const FlLine(
                    color: Color(0xff37434d),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                       final format = NumberFormat.compact();
                      return Text(format.format(value), style: const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.left);
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d)),
              ),
              minX: 0,
              maxX: (reversedTrades.length - 1).toDouble(),
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [Color(0xff23b6e6), Color(0xff02d39a)],
                  ),
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [const Color(0xff23b6e6).withOpacity(0.3), const Color(0xff02d39a).withOpacity(0.3)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
