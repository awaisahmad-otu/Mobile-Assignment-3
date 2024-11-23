import 'package:flutter/material.dart';
import 'food_item.dart';
import 'database_helper.dart';

void main() => runApp(FoodOrderingApp());

class FoodOrderingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FoodOrderingScreen(),
    );
  }
}

class FoodOrderingScreen extends StatefulWidget {
  @override
  _FoodOrderingScreenState createState() => _FoodOrderingScreenState();
}

class _FoodOrderingScreenState extends State<FoodOrderingScreen> {
  final List<FoodItem> foodItems = [
    FoodItem("Pizza", 8.99),
    FoodItem("Burger", 5.99),
    FoodItem("Salad", 3.99),
    FoodItem("Pasta", 7.99),
    // Add more food items
    FoodItem("Sushi", 12.99),
    FoodItem("Steak", 15.99),
    FoodItem("Soup", 4.99),
    FoodItem("Taco", 6.99),
    FoodItem("Fried Rice", 9.99),
    FoodItem("Sandwich", 4.49),
    FoodItem("Fries", 2.99),
    FoodItem("Chicken Wings", 10.99),
    FoodItem("Ice Cream", 3.49),
    FoodItem("Pancakes", 6.49),
    FoodItem("Curry", 11.99),
    FoodItem("Wrap", 7.49),
    FoodItem("Noodles", 8.49),
    FoodItem("BBQ", 14.99),
    FoodItem("Fruit Bowl", 5.49),
    FoodItem("Hot Dog", 4.99),
  ];

  final TextEditingController targetCostController = TextEditingController();
  String selectedDate = '';
  List<FoodItem> selectedFoods = [];
  double totalCost = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Ordering App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: targetCostController,
              decoration: InputDecoration(labelText: "Target Cost per Day (\$)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text("Select Date"),
            ),
            SizedBox(height: 16),
            Text("Selected Date: $selectedDate"),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = foodItems[index];
                  return ListTile(
                    title: Text(foodItem.name),
                    subtitle: Text("\$${foodItem.cost}"),
                    trailing: Checkbox(
                      value: selectedFoods.contains(foodItem),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected!) {
                            selectedFoods.add(foodItem);
                          } else {
                            selectedFoods.remove(foodItem);
                          }
                          totalCost = selectedFoods.fold(0, (sum, item) => sum + item.cost);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Text("Total Cost: \$${totalCost.toStringAsFixed(2)}"),
            ElevatedButton(
              onPressed: _saveOrder,
              child: Text("Save Order"),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _saveOrder() {
    if (selectedDate.isNotEmpty) {
      for (var food in selectedFoods) {
        DatabaseHelper.instance.insertOrder(selectedDate, food.name, food.cost);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order saved!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a date!")));
    }
  }
}
