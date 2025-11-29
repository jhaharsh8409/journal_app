import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/home_backend.dart';
import '../utils/colors.dart';
import '../utils/icons.dart';

class add_trade_dialog extends StatefulWidget {
  final dynamic screenWidth;
  final dynamic screenHeight;

  const add_trade_dialog({super.key, required this.screenWidth, required this.screenHeight});

  @override
  State<add_trade_dialog> createState() => _add_trade_dialogState();
}

class _add_trade_dialogState extends State<add_trade_dialog> {
  final HomeBackend _homeBackend = HomeBackend();

  // State variables for the form fields
  String? _symbol;
  final List<String> _symbols = ['BTC', 'ETH'];
  DateTime _selectedDate = DateTime.now();
  String? _positionType;
  String? _tradeOutcome;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTrade() async {
    if (_symbol == null || _positionType == null || _tradeOutcome == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _homeBackend.addTrade(
        symbol: _symbol!,
        date: _selectedDate,
        positionType: _positionType!,
        tradeOutcome: _tradeOutcome!,
        amount: double.parse(_amountController.text),
        notes: _notesController.text,
      );

      Navigator.of(context).pop(); // Close the dialog on success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trade added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add trade: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text('Add New Trade', style: TextStyle(fontSize: widget.screenWidth * 0.05, fontWeight: FontWeight.bold)),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      // --- DATE PICKER ---
                      InkWell(
                        onTap: () => _selectDate(context, setState),
                        child: Row(
                          children: [
                            Text("Date", style: TextStyle(fontSize: widget.screenWidth * 0.04)),
                            SizedBox(width: widget.screenWidth * 0.02),
                            Expanded(child: Container(height: 1, color: ColorHelper.colors[9])),
                            SizedBox(width: widget.screenWidth * 0.02),
                            Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: TextStyle(fontSize: widget.screenWidth * 0.04)),
                            SizedBox(width: widget.screenWidth * 0.01),
                            Icon(IconHelper.icons[6], size: widget.screenWidth * 0.04),
                          ],
                        ),
                      ),
                      SizedBox(height: widget.screenHeight * 0.02),

                      // --- SYMBOL DROPDOWN ---
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.03, vertical: widget.screenHeight * 0.005),
                        decoration: BoxDecoration(
                          color: ColorHelper.colors[9],
                          borderRadius: BorderRadius.circular(widget.screenWidth * 0.025),
                        ),
                        child: DropdownButton<String>(
                          value: _symbol,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text("Select Symbol", style: TextStyle(fontSize: widget.screenWidth * 0.04)),
                          onChanged: (String? newValue) {
                            setState(() => _symbol = newValue);
                          },
                          items: _symbols.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value, style: TextStyle(fontSize: widget.screenWidth * 0.04)));
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: widget.screenHeight * 0.02),

                      // --- POSITION TYPE ---
                      Text("Position Type", style: TextStyle(fontSize: widget.screenWidth * 0.04)),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Long', style: TextStyle(fontSize: widget.screenWidth * 0.035)),
                              value: 'Long',
                              groupValue: _positionType,
                              onChanged: (value) => setState(() => _positionType = value),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Short', style: TextStyle(fontSize: widget.screenWidth * 0.035)),
                              value: 'Short',
                              groupValue: _positionType,
                              onChanged: (value) => setState(() => _positionType = value),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: widget.screenHeight * 0.01),

                      // --- PROFIT/LOSS ---
                      Text("Outcome", style: TextStyle(fontSize: widget.screenWidth * 0.04)),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Profit', style: TextStyle(fontSize: widget.screenWidth * 0.035)),
                              value: 'Profit',
                              groupValue: _tradeOutcome,
                              onChanged: (value) => setState(() => _tradeOutcome = value),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Loss', style: TextStyle(fontSize: widget.screenWidth * 0.035)),
                              value: 'Loss',
                              groupValue: _tradeOutcome,
                              onChanged: (value) => setState(() => _tradeOutcome = value),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Enter Amount in \$',
                          isDense: true,
                          hintStyle: TextStyle(fontSize: widget.screenWidth * 0.04),
                        ),
                        style: TextStyle(fontSize: widget.screenWidth * 0.04),
                      ),
                      SizedBox(height: widget.screenHeight * 0.03),

                      // --- NOTES ---
                      Text("Notes", style: TextStyle(fontSize: widget.screenWidth * 0.04)),
                      SizedBox(height: widget.screenHeight * 0.01),
                      TextField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter your notes here...',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(fontSize: widget.screenWidth * 0.04),
                        ),
                        style: TextStyle(fontSize: widget.screenWidth * 0.04),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : TextButton(
                          child: const Text('Save'),
                          onPressed: _saveTrade,
                        ),
                ],
              );
            });
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: widget.screenHeight * 0.01, horizontal: widget.screenWidth * 0.01),
        decoration: BoxDecoration(
            color: ColorHelper.colors[10],
            borderRadius: BorderRadius.all(Radius.circular(widget.screenWidth * 0.025))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconHelper.icons[1],
              color: ColorHelper.colors[11],
              size: widget.screenWidth * 0.05,
            ),
            SizedBox(
              width: widget.screenWidth * 0.02,
            ),
            Text(
              "Add Trade",
              style: TextStyle(
                  color: ColorHelper.colors[11],
                  fontWeight: FontWeight.bold,
                  fontSize: widget.screenWidth * 0.035),
            )
          ],
        ),
      ),
    );
  }
}
