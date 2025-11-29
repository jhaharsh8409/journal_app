import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:journal/api/home_backend.dart';
import 'package:journal/components/trade_card.dart';

class AllTradesScreen extends StatelessWidget {
  final HomeBackend _backend = HomeBackend();

  AllTradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Trades'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _backend.getTrades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No trades found.'));
          }

          final trades = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trades.length,
            itemBuilder: (context, index) {
              final trade = trades[index];
              return TradeCard(
                key: ValueKey(trade.id), // <-- THIS IS THE FIX
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
          );
        },
      ),
    );
  }
}
