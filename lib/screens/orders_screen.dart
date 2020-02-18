import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Firestore firestore = fb.firestore();

  void _showDeleteDialog(var ds, var i) {
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
                  // firestore.collection('orders').doc(ds['id']).delete();
                  // orders.remove(ds);
                  // // ordersDataRows.removeAt(i - 1);
                  // Navigator.pop(context);
                  print(i);
                });
              },
            )
          ],
        );
      },
    );
  }

  List orders = [];
  List ordersDataRows = [];

  @override
  void initState() {
    super.initState();

    firestore.collection('orders').get().then((order) {
      int i = 0;
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
              var order = {
                'id': o.id,
                'customer': cus.data(),
                'product': prod.data(),
                'address': o.data()['address'],
                'quantity': o.data()['quantity'],
                'size': o.data()['size'],
                'status': o.data()['status'],
              };
              orders.add(order);

              i++;

              DataRow row = DataRow(cells: [
                DataCell(Text('$i')),
                DataCell(Text(
                  '${cus.data()['firstname']} ${cus.data()['lastname']}',
                )),
                DataCell(Text(
                  '${prod.data()['name']}',
                )),
                DataCell(Text(
                  '${prod.data()['design']}',
                )),
                DataCell(Text(
                  '${o.data()['size']}',
                )),
                DataCell(Text(
                  '${o.data()['quantity']}',
                )),
                DataCell(Text(
                  '${o.data()['address']}',
                )),
                DataCell(Text(
                  '${cus.data()['mobile']}',
                )),
                DataCell(
                  Text(
                    '${o.data()['status']}',
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/edit_order',
                        // arguments: orders[index],
                      );
                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteDialog(order, i);
                    },
                  ),
                ),
              ]);

              ordersDataRows.add(row);
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DataTable(
        columns: [
          DataColumn(numeric: true, label: Text('#')),
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Design')),
          DataColumn(label: Text('Size')),
          DataColumn(numeric: true, label: Text('Quantity')),
          DataColumn(label: Text('Address')),
          DataColumn(numeric: true, label: Text('Mobile')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Edit')),
          DataColumn(label: Text('Delete')),
        ],
        rows: List.unmodifiable(() sync* {
          yield* ordersDataRows;
        }()),
      ),
      // body: ListView.builder(
      //     itemCount: orders.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return orders.isEmpty
      //           ? CircularProgressIndicator()
      //           : ListTile(
      //               leading: Icon(
      //                 Icons.assignment,
      //                 color: Colors.black,
      //               ),
      //               title: Text(orders[index]['customer']['firstname']),
      //               subtitle: Text(orders[index]['product']['name']),
      //               trailing: PopupMenuButton(
      //                 color: Colors.white,
      //                 itemBuilder: (context) => [
      //                   PopupMenuItem(
      //                     value: 1,
      //                     child: FlatButton(
      //                       child: Text('Edit'),
      //                       onPressed: () {
      //                         Navigator.of(context).pushNamed(
      //                           '/edit_order',
      //                           arguments: orders[index],
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                   PopupMenuItem(
      //                     value: 2,
      //                     child: FlatButton(
      //                       child: Text('Delete'),
      //                       onPressed: () {
      //                         _showDeleteDialog(orders[index]);
      //                       },
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             );
      //     }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/add_orders');
        },
      ),
    );
  }
}
