import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal/api/global_data.dart';

class HomeBackend {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a new trade
  Future<void> addTrade({
    required String symbol,
    required DateTime date,
    required String positionType,
    required String tradeOutcome,
    required double amount,
    required String notes,
  }) async {
    try {
      if (global_data.userId.isNotEmpty) {
        await _firestore.collection('trades').add({
          'userId': global_data.userId,
          'symbol': symbol,
          'date': Timestamp.fromDate(date),
          'positionType': positionType,
          'tradeOutcome': tradeOutcome,
          'amount': amount,
          'notes': notes,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        throw Exception('User ID is not available.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Function to get a stream of trades for the current user
  Stream<QuerySnapshot> getTrades() {
    if (global_data.userId.isNotEmpty) {
      return _firestore
          .collection('trades')
          .where('userId', isEqualTo: global_data.userId)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      // Return an empty stream if the user is not logged in
      return Stream.empty();
    }
  }

  // Function to delete a trade
  Future<void> deleteTrade(String tradeId) async {
    try {
      await _firestore.collection('trades').doc(tradeId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Function to calculate total Pnl
  double calculateTotalPnl(List<QueryDocumentSnapshot> trades) {
    double totalPnl = 0;
    for (var trade in trades) {
      final amount = trade['amount'] as double;
      final outcome = trade['tradeOutcome'] as String;
      if (outcome == 'Profit') {
        totalPnl += amount;
      } else {
        totalPnl -= amount;
      }
    }
    return totalPnl;
  }
}
