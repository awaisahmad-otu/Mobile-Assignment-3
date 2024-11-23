import 'package:flutter/material.dart';
import 'database_helper.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String date;

  OrderHistoryScreen({required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History for $date"),
      ),
      body: FutureBuilder(
        future: DatabaseHelper.instance.getOrdersForDate(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No orders found for this date"));
          }

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
