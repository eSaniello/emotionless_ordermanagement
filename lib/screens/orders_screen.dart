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
            setState(() {
              var order = {
                'id': o.id,
                'customer': cus,
                'product': prod,
                'address': o.data()['address'],
                'quantity': o.data()['quantity'],
                'size': o.data()['size'],
                'status': o.data()['status'],
              };
              orders.add(order);
            });
          });
        });
      });
    });
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 7) {
      if (ascending) {
        orders.sort((a, b) => a['status'].compareTo(b['status']));
      } else {
        orders.sort((a, b) => b['status'].compareTo(a['status']));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: DataTable(
          sortAscending: sort,
          sortColumnIndex: 7,
          columns: [
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Product')),
            DataColumn(label: Text('Design')),
            DataColumn(label: Text('Size')),
            DataColumn(numeric: true, label: Text('Quantity')),
            DataColumn(label: Text('Address')),
            DataColumn(numeric: true, label: Text('Mobile')),
            DataColumn(
                label: Text('Status'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSortColum(columnIndex, ascending);
                }),
            DataColumn(label: Text('Edit')),
            DataColumn(label: Text('Delete')),
          ],
          rows: orders
              .map((order) => DataRow(cells: [
                    DataCell(Text(
                      '${order['customer'].data()['firstname']} ${order['customer'].data()['lastname']}',
                    )),
                    DataCell(Text(
                      '${order['product'].data()['name']}',
                    )),
                    DataCell(Text(
                      '${order['product'].data()['design']}',
                    )),
                    DataCell(Text(
                      '${order['size']}',
                    )),
                    DataCell(Text(
                      '${order['quantity']}',
                    )),
                    DataCell(Text(
                      '${order['address']}',
                    )),
                    DataCell(Text(
                      '${order['customer'].data()['mobile']}',
                    )),
                    DataCell(
                      Text(
                        '${order['status']}',
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/edit_order',
                            arguments: order,
                          );
                        },
                      ).showCursorOnHover,
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(order);
                        },
                      ).showCursorOnHover,
                    ),
                  ]))
              .toList(),
        ),
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
