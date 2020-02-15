import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Firestore firestore = fb.firestore();

  void _showDeleteDialog(DocumentSnapshot ds) {
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
                firestore.collection('orders').doc(ds.id).delete();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();

    firestore.collection('orders').get().then((value) {
      value.docs.forEach((doc) {
        var customer;
        var product;
        firestore
            .collection('customers')
            .doc(doc.data()['customer'])
            .get()
            .then((cus) {
          customer = cus;
          firestore
              .collection('products')
              .doc(doc.data()['product'])
              .get()
              .then((prod) {
            product = prod;
            orders.add({
              'id:': doc.id,
              'customer': customer,
              'product': product,
              'size': doc.data()['size'],
              'quantity': doc.data()['quantity'],
              'address': doc.data()['address'],
            });
          });
        });
      });

      print(orders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: firestore.collection('orders').onSnapshot,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                return ListTile(
                  leading: Icon(
                    Icons.assignment,
                    color: Colors.black,
                  ),
                  title: Text('${ds.data()['customer']}'),
                  subtitle: Text(ds.data()['customer']),
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
                              arguments: ds,
                            );
                          },
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: FlatButton(
                          child: Text('Delete'),
                          onPressed: () {
                            _showDeleteDialog(ds);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add_orders');
        },
      ),
    );
  }
}
