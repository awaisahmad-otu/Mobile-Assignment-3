import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'order_history.dart';

void main(){
  runApp(FoodOrderingApp());
}

class FoodOrderingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FoodOrderingScreen(),
    );
  }
}

// widget for food ordering screen
class FoodOrderingScreen extends StatefulWidget {
  @override
  _FoodOrderingScreenState createState() => _FoodOrderingScreenState();
}

// class for food items
class FoodItem {
  final String name;
  final double cost;

  FoodItem(this.name, this.cost);
}

class _FoodOrderingScreenState extends State<FoodOrderingScreen> {
  // 20 preferred food item and cost pairs
  final List<FoodItem> foodItems = [
    FoodItem("Pizza", 8.99),
    FoodItem("Burger", 5.99),
    FoodItem("Salad", 3.99),
    FoodItem("Pasta", 7.99),
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

  // manage the text input target cost per day
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
            // input field for target cost per day
            TextField(
              controller: targetCostController,
              decoration: InputDecoration(labelText: "Target Cost per Day (\$)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // select a date for the order
            ElevatedButton(
              onPressed: _selectDate,
              child: Text("Select Date"),
            ),
            SizedBox(height: 16),
            // display selected date
            Text("Selected Date: $selectedDate"),
            Expanded(
              // display the list of food items
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
                          // update total cost based on selected items
                          totalCost = selectedFoods.fold(0, (sum, item) => sum + item.cost);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // display total cost of selected food items
            Text("Total Cost: \$${totalCost.toStringAsFixed(2)}"),
            // save the order
            ElevatedButton(
              onPressed: _saveOrder,
              child: Text("Save Order"),
            ),
            SizedBox(height: 16),
            // view order history
            ElevatedButton(
              onPressed: _viewOrderHistory,
              child: Text("View Order History"),
            ),
          ],
        ),
      ),
    );
  }

  // function to allow the user to select a date
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

  // function to save the selected order to the database
  void _saveOrder() {
    final targetCost = double.tryParse(targetCostController.text) ?? 0;

    if (selectedDate.isNotEmpty) {
      // Check if the total cost is within the target
      if (totalCost <= targetCost) {
        for (var food in selectedFoods) {
          // format date
          String formattedDate = selectedDate;
          DatabaseHelper.instance.insertOrder(formattedDate, food.name, food.cost);
        }
        // confirm the order has been saved
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order saved!")));
      } else {
        // show an error if the total cost exceeds the target cost
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Total cost exceeds target amount!")));
      }
    } else {
      // show an error message if no date selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a date!")));
    }
  }

  // function to navigate to order history screen
  void _viewOrderHistory() {
    if (selectedDate.isNotEmpty) {
      // navigate to the OrderHistoryScreen and pass the selected date
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderHistoryScreen(date: selectedDate),
        ),
      );
    } else {
      // show an error if no date is selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a date first!")));
    }
  }
}
