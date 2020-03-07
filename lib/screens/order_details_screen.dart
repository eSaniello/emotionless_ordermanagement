import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map order;

  OrderDetailsScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order details'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text('Status: ${order['status']}'),
            Text(
                'Order date: ${DateFormat("dd-MMM-yyyy").format(order['date'])}'),
            Text(
                'Customer: ${order['customer'].data()['firstname']} ${order['customer'].data()['lastname']}'),
            Text('Address: ${order['address']}'),
            Text('Mobile: ${order['customer'].data()['mobile']}'),
            Text('Product: ${order['product'].data()['name']}'),
            Text('Design: ${order['design'].data()['design']}'),
            Text('Size: ${order['size']}'),
            Text('Quantity: ${order['quantity']}'),
            Text('Color: ${order['color'].data()['color']}'),
          ],
        ),
      ),
    );
  }
}
