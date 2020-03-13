import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import '../extensions/hover_extensions.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Firestore firestore = fb.firestore();

  void _showDeleteDialog(var order) {
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
                  firestore.collection('orders').doc(order['id']).delete();
                  orders.remove(order);
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
  bool sort;

  @override
  void initState() {
    super.initState();

    sort = false;

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
            firestore
                .collection('designs')
                .doc(o.data()['design'])
                .get()
                .then((design) {
              setState(() {
                var order = {
                  'id': o.id,
                  'customer': cus,
                  'product': prod,
                  'design': design,
                  // 'color': color,
                  'address': o.data()['address'],
                  'quantity': o.data()['quantity'],
                  'size': o.data()['size'],
                  'status': o.data()['status'],
                  'date': o.data()['date'],
                };
                orders.add(order);
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text('sort'),
                sort == false
                    ? Icon(Icons.arrow_upward)
                    : Icon(Icons.arrow_downward),
              ],
            ),
            onPressed: () {
              setState(() {
                sort = !sort;

                if (sort) {
                  orders.sort((a, b) => a['status'].compareTo(b['status']));
                } else {
                  orders.sort((a, b) => b['status'].compareTo(a['status']));
                }
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: PopupMenuButton(
                    child: Text(orders[index]['status']),
                    color: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 2,
                          child: FlatButton(
                            child: Text('pending'),
                            onPressed: () {
                              firestore
                                  .collection('orders')
                                  .doc(orders[index]['id'])
                                  .update(data: {
                                'status': 'pending',
                              });
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                          )),
                      PopupMenuItem(
                          value: 2,
                          child: FlatButton(
                            child: Text('delivered'),
                            onPressed: () {
                              firestore
                                  .collection('orders')
                                  .doc(orders[index]['id'])
                                  .update(data: {
                                'status': 'delivered',
                              });
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                          )),
                      PopupMenuItem(
                          value: 2,
                          child: FlatButton(
                            child: Text('ordered'),
                            onPressed: () {
                              firestore
                                  .collection('orders')
                                  .doc(orders[index]['id'])
                                  .update(data: {
                                'status': 'ordered',
                              });
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                          )),
                    ],
                  ).showCursorOnHover,
                  title: Text(
                    orders[index]['customer'].data()['firstname'] +
                        ' ' +
                        orders[index]['customer'].data()['lastname'],
                  ),
                  subtitle: Text(
                      "${orders[index]['quantity']}X ${orders[index]['product'].data()['name']}, ${orders[index]['design'].data()['design']} design"),
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
                  ).showCursorOnHover,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/order_details',
                      arguments: orders[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/add_orders');
        },
      ).showCursorOnHover,
    );
  }
}
