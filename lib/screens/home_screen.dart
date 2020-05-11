import 'package:emotionless/screens/customers_screen.dart';
import 'package:emotionless/screens/orders_screen.dart';
import 'package:emotionless/screens/products_screen.dart';
import 'package:flutter/material.dart';
import '../extensions/hover_extensions.dart';

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
          leading: Image.asset(
            'logo.png',
            fit: BoxFit.contain,
            // width: 100,
            // height: 100,
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Orders', icon: Icon(Icons.shopping_basket))
                  .showCursorOnHover,
              Tab(text: 'Customers', icon: Icon(Icons.people))
                  .showCursorOnHover,
              Tab(text: 'Products', icon: Icon(Icons.spa)).showCursorOnHover,
            ],
          ),
          title: Text('Emotionless Order Management'),
          actions: <Widget>[
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) => [
                // PopupMenuItem(
                //   value: 1,
                //   child: FlatButton(
                //     child: Text('Colors'),
                //     onPressed: () {
                //       Navigator.of(context).pushNamed('/colors');
                //     },
                //   ).showCursorOnHover,
                // ),
                PopupMenuItem(
                  value: 2,
                  child: FlatButton(
                    child: Text('Designs'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/designs');
                    },
                  ),
                ),
              ],
            ).showCursorOnHover,
          ],
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
