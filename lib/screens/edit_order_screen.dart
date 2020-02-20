import 'package:flutter/material.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import '../extensions/hover_extensions.dart';

class EditOrder extends StatefulWidget {
  final Map order;

  EditOrder(this.order);

  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  final Firestore firestore = fb.firestore();
  TextEditingController size = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController address = TextEditingController();

  DocumentSnapshot selectedCustomer;
  List<DocumentSnapshot> customers = <DocumentSnapshot>[];

  DocumentSnapshot selectedProduct;
  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  String selectedStatus;
  List<String> status = <String>[];

  @override
  void initState() {
    super.initState();

    firestore.collection('customers').get().then((value) {
      setState(() {
        value.forEach((doc) {
          customers.add(doc);
        });

        selectedCustomer = customers
            .firstWhere((element) => element.id == widget.order['customer'].id);
      });
    });

    firestore.collection('products').get().then((value) {
      setState(() {
        value.forEach((doc) {
          products.add(doc);
        });

        selectedProduct = products
            .firstWhere((element) => element.id == widget.order['product'].id);
      });
    });

    status.add('pending');
    status.add('delivered');
    selectedStatus =
        status.firstWhere((element) => element == widget.order['status']);

    size.text = widget.order['size'];
    quantity.text = widget.order['quantity'];
    address.text = widget.order['address'];
  }

  void _showConfirmDialog(
    String orderId,
    DocumentSnapshot customer,
    DocumentSnapshot product,
    String address,
    String quantity,
    String size,
    String status,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          actions: <Widget>[
            FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).showCursorOnHover,
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                firestore.collection('orders').doc(orderId).update(data: {
                  'customer': customer.id,
                  'product': product.id,
                  'size': size,
                  'quantity': quantity,
                  'status': status,
                  'address': address,
                });
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ).showCursorOnHover,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit order'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DropdownButton<DocumentSnapshot>(
              hint: Text("Select customer"),
              value: selectedCustomer,
              onChanged: (DocumentSnapshot value) {
                setState(() {
                  selectedCustomer = value;
                });
              },
              items: customers.map((DocumentSnapshot user) {
                return DropdownMenuItem<DocumentSnapshot>(
                  value: user,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.data()['firstname'] +
                            " " +
                            user.data()['lastname'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ).showCursorOnHover,
            DropdownButton<DocumentSnapshot>(
              hint: Text("Select product"),
              value: selectedProduct,
              onChanged: (DocumentSnapshot value) {
                setState(() {
                  selectedProduct = value;
                });
              },
              items: products.map((DocumentSnapshot prod) {
                return DropdownMenuItem<DocumentSnapshot>(
                  value: prod,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        prod.data()['name'] + " || " + prod.data()['design'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ).showCursorOnHover,
            TextField(
              controller: size,
              decoration: InputDecoration(hintText: 'Size'),
            ),
            TextField(
              controller: quantity,
              decoration: InputDecoration(hintText: 'Quantity'),
            ),
            TextField(
              controller: address,
              decoration: InputDecoration(hintText: 'Address'),
            ),
            DropdownButton<String>(
              hint: Text("Status"),
              value: selectedStatus,
              onChanged: (String value) {
                setState(() {
                  selectedStatus = value;
                });
              },
              items: status.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        status,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ).showCursorOnHover,
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ).showCursorOnHover,
            RaisedButton(
              child: Text('Update order'),
              onPressed: () {
                _showConfirmDialog(
                  widget.order['id'],
                  selectedCustomer,
                  selectedProduct,
                  address.text,
                  quantity.text,
                  size.text,
                  selectedStatus,
                );
              },
            ).showCursorOnHover,
          ],
        ),
      ),
    );
  }
}
