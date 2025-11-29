import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal/utils/colors.dart';
import 'package:journal/utils/icons.dart';

import '../api/home_backend.dart';

class TradeCard extends StatelessWidget {
  final String tradeId;
  final String symbol;
  final String positionType;
  final double amount;
  final DateTime date;
  final String notes;
  final String tradeOutcome;
  final HomeBackend backend;

  const TradeCard({
    super.key,
    required this.tradeId,
    required this.symbol,
    required this.positionType,
    required this.amount,
    required this.date,
    required this.notes,
    required this.tradeOutcome,
    required this.backend,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isProfit = tradeOutcome == 'Profit';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isProfit ? IconHelper.icons[4] : IconHelper.icons[5],
                      color: isProfit ? ColorHelper.colors[2] : ColorHelper.colors[1],
                      size: screenWidth * 0.07,
                    ),
                    const SizedBox(width: 8),
                    Text(symbol, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorHelper.colors[10],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        positionType.toUpperCase(),
                        style: TextStyle(color: ColorHelper.colors[11], fontSize: screenWidth * 0.025, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isProfit ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isProfit ? ColorHelper.colors[2] : ColorHelper.colors[1],
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(IconHelper.icons[2], size: screenWidth * 0.035, color: ColorHelper.colors[9]),
                const SizedBox(width: 4),
                Text(DateFormat('dd/MM/yyyy').format(date), style: TextStyle(fontSize: screenWidth * 0.035, color: ColorHelper.colors[9])),
              ],
            ),
            if (notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorHelper.grey_100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(notes, style: TextStyle(fontSize: screenWidth * 0.038)),
                ),
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                icon: Icon(IconHelper.icons[3], color: ColorHelper.colors[1], size: 20),
                label: Text('Delete', style: TextStyle(color: ColorHelper.colors[1])),
                onPressed: () async {
                  await backend.deleteTrade(tradeId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
