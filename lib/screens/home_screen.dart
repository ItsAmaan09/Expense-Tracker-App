import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  Widget _buildSummaryCard() {
    double total = expenses.fold(0, (sum, item) => sum + item.amount);

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.indigoAccent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '₹${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList() {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No expenses yet. Add some!',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.money, color: Colors.green),
            title: Text(
              expense.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(expense.category),
            trailing: Text(
              '₹${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _addExpense() {
    String title = '';
    String amount = '';
    String selectedCategory = 'Food';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Expense"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildSummaryCard(),
                Expanded(child: _buildExpenseList()),
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => amount = value,
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  items:
                      ['Food', 'Travel', 'Entertainment', 'Other']
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
                TextButton(
                  child: Text(
                    "Pick date: ${selectedDate.toLocal().toString().split('')[0]}",
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                if (title.isNotEmpty && amount.isNotEmpty) {
                  setState(() {
                    expenses.add(
                      Expense(
                        title: title,
                        amount: double.tryParse(amount) ?? 0,
                        date: selectedDate,
                        category: selectedCategory,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _addExpense)],
      ),
      body:
          expenses.isEmpty
              ? Center(child: Text("No expenses added yet."))
              : ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final exp = expenses[index];
                  return ListTile(
                    title: Text(exp.title),
                    subtitle: Text("\$₹{exp.amount.toStringAsFixed(2)}"),
                    trailing: Text(exp.category),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: Icon(Icons.add),
      ),
    );
  }
}
