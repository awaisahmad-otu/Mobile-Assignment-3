import 'package:flutter/material.dart';
import 'database_helper.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String date;

  // receive the date for the order history that needs to be displayed
  OrderHistoryScreen({required this.date});

  // function to remove an order from the database
  Future<void> _removeOrder(int orderId) async {
    await DatabaseHelper.instance.removeOrder(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History for $date"),
      ),
      body: FutureBuilder(
        // fetch orders from the database for the given date
        future: DatabaseHelper.instance.getOrdersForDate(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // display a message if no data is found or the data is empty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No orders found for this date"));
          }

          // once the data is available, process and display it in a list
          final orders = snapshot.data! as List<Map<String, dynamic>>;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return ListTile(
                title: Text(order['food_item']),
                subtitle: Text("\$${order['cost']}"),
                trailing: IconButton(
                  // remove item from order history
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Remove Item"),
                          content: Text("Are you sure you want to remove ${order['food_item']} from the cart?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _removeOrder(order['id']);  // Remove the order
                                Navigator.of(context).pop();  // Close the dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${order['food_item']} removed from the cart")),
                                );
                              },
                              child: Text("Remove"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
