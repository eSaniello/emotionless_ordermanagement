import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import '../extensions/hover_extensions.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

//TODO: Pending tot een dropdown creeren.

//TODO: Item/aantal en design info ook zichtbaar zijn in listtiles

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
                  leading: Text(orders[index]['status']),
                  title: Text(
                    orders[index]['customer'].data()['firstname'] +
                        ' ' +
                        orders[index]['customer'].data()['lastname'],
                  ),
                  subtitle: Text(orders[index]['product'].data()['name']),
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
      // SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //   child: DataTable(
      //     sortAscending: sort,
      //     sortColumnIndex: 8,
      //     columns: [
      //       DataColumn(label: Text('Order date')),
      //       DataColumn(label: Text('Customer')),
      //       DataColumn(label: Text('Product')),
      //       DataColumn(label: Text('Design')),
      //       DataColumn(label: Text('Size')),
      //       DataColumn(numeric: true, label: Text('Quantity')),
      //       DataColumn(label: Text('Address')),
      //       DataColumn(numeric: true, label: Text('Mobile')),
      //       DataColumn(
      //           label: Text('Status'),
      //           onSort: (columnIndex, ascending) {
      //             setState(() {
      //               sort = !sort;
      //             });
      //             onSortColum(columnIndex, ascending);
      //           }),
      //       DataColumn(label: Text('Edit / Delete')),
      //     ],
      //     rows: orders
      //         .map((order) => DataRow(cells: [
      //               DataCell(
      //                 Text(
      //                   '${DateFormat("dd-MMM-yyyy").format(order['date'])}',
      //                 ),
      //               ),
      //               DataCell(Text(
      //                 '${order['customer'].data()['firstname']} ${order['customer'].data()['lastname']}',
      //               )),
      //               DataCell(Text(
      //                 '${order['product'].data()['name']}',
      //               )),
      //               DataCell(Text(
      //                 '${order['design'].data()['design']}',
      //               )),
      //               DataCell(Text(
      //                 '${order['size']}',
      //               )),
      //               DataCell(Text(
      //                 '${order['quantity']}',
      //               )),
      //               DataCell(Text(
      //                 '${order['address']}',
      //               )),
      //               DataCell(Text(
      //                 '${order['customer'].data()['mobile']}',
      //               )),
      //               DataCell(
      //                 Text(
      //                   '${order['status']}',
      //                 ),
      //               ),
      //               DataCell(
      //                 Row(
      //                   children: <Widget>[
      //                     IconButton(
      //                       icon: Icon(Icons.edit),
      //                       onPressed: () {
      //                         Navigator.of(context).pushNamed(
      //                           '/edit_order',
      //                           arguments: order,
      //                         );
      //                       },
      //                     ).showCursorOnHover,
      //                     IconButton(
      //                       icon: Icon(Icons.delete),
      //                       onPressed: () {
      //                         _showDeleteDialog(order);
      //                       },
      //                     ).showCursorOnHover,
      //                   ],
      //                 ),
      //               ),
      //             ]))
      //         .toList(),
      //   ),
      // ),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/add_orders');
        },
      ).showCursorOnHover,
    );
  }
}
