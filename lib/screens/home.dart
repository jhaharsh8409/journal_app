import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal/api/global_data.dart';
import 'package:journal/api/home_backend.dart';
import 'package:journal/components/add_trade_dialog.dart';
import 'package:journal/components/logout_button.dart';
import 'package:journal/components/pnl_chart.dart';
import 'package:journal/components/trade_card.dart';
import 'package:journal/utils/colors.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final HomeBackend _backend = HomeBackend();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.045),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${global_data.username}'s Journal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.055,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          "Track and analyse your trades",
                          style: TextStyle(
                            color: ColorHelper.text_color,
                            fontSize: screenWidth * 0.035,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    flex: 1,
                    child: add_trade_dialog(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _backend.getTrades(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          const Expanded(
                            child: Center(
                                child: Text(
                              'No trades found. Add a new trade to get started!',
                              textAlign: TextAlign.center,
                            )),
                          ),
                          logout_button()
                        ],
                      ));
                    }

                    final trades = snapshot.data!.docs;
                    double totalPnl = 0;
                    trades.forEach((trade) {
                      final amount = trade['amount'] as double;
                      final outcome = trade['tradeOutcome'] as String;
                      if (outcome == 'Profit') {
                        totalPnl += amount;
                      } else {
                        totalPnl -= amount;
                      }
                    });

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Current PnL: \$${totalPnl.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: totalPnl >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        PnlChart(trades: trades),
                        const SizedBox(height: 10),

                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: trades.length,
                            itemBuilder: (context, index) {
                              var trade = trades[index];
                              return TradeCard(
                                tradeId: trade.id,
                                symbol: trade['symbol'],
                                positionType: trade['positionType'],
                                amount: trade['amount'],
                                date: (trade['date'] as Timestamp).toDate(),
                                notes: trade['notes'],
                                tradeOutcome: trade['tradeOutcome'],
                                backend: _backend,
                              );
                            },
                          ),
                        ),
                        logout_button()
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
