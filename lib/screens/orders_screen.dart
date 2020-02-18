import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Firestore firestore = fb.firestore();

  void _showDeleteDialog(var ds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This order will be permanently deleted!'),
          actions: <Widget>[
            FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  firestore.collection('orders').doc(ds['id']).delete();
                  orders.remove(ds);
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            )
          ],
        );
      },
    );
  }

  List orders = [];

  @override
  void initState() {
    super.initState();

    firestore.collection('orders').get().then((order) {
      order.forEach((o) {
        firestore
            .collection('customers')
            .doc(o.data()['customer'])
            .get()
            .then((cus) {
          firestore
              .collection('products')
              .doc(o.data()['product'])
              .get()
              .then((prod) {
            setState(() {
              orders.add({
                'id': o.id,
                'customer': cus.data(),
                'product': prod.data(),
                'address': o.data()['address'],
                'quantity': o.data()['quantity'],
                'size': o.data()['size'],
                'status': o.data()['status'],
              });
            });
          });
        });
      });
    });
  }

  Color iconColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            return orders.isEmpty
                ? CircularProgressIndicator()
                : ListTile(
                    leading: Icon(
                      Icons.assignment,
                      color: iconColor,
                    ),
                    title: Text(orders[index]['customer']['firstname']),
                    subtitle: Text(orders[index]['product']['name']),
                    trailing: PopupMenuButton(
                      color: Colors.white,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: FlatButton(
                            child: Text('Edit'),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                '/edit_order',
                                arguments: orders[index],
                              );
                            },
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: FlatButton(
                            child: Text('Delete'),
                            onPressed: () {
                              _showDeleteDialog(orders[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/add_orders');
        },
      ),
    );
  }
}
