import 'package:emotionless/screens/customers_screen.dart';
import 'package:emotionless/screens/orders_screen.dart';
import 'package:emotionless/screens/products_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Orders', icon: Icon(Icons.shopping_basket)),
              Tab(text: 'Customers', icon: Icon(Icons.people)),
              Tab(text: 'Products', icon: Icon(Icons.spa)),
            ],
          ),
          title: Text('Emotionless Order Management'),
        ),
        body: TabBarView(
          children: [
            OrdersScreen(),
            CustomersScreen(),
            ProductsScreen(),
          ],
        ),
      ),
    );
  }
}
