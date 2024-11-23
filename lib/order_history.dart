import 'package:flutter/material.dart';
import 'database_helper.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String date;

  // receive the date for the order history that needs to be displayed
  OrderHistoryScreen({required this.date});

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
              );
            },
          );
        },
      ),
    );
  }
}
