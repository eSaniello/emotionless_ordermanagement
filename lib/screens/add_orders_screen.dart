import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import '../extensions/hover_extensions.dart';

class AddOrders extends StatefulWidget {
  @override
  _AddOrdersState createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  final Firestore firestore = fb.firestore();
  TextEditingController size = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController address = TextEditingController();

  DocumentSnapshot selectedCustomer;
  List<DocumentSnapshot> customers = <DocumentSnapshot>[];

  DocumentSnapshot selectedProduct;
  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  bool isEmpty;

  @override
  void initState() {
    super.initState();

    isEmpty = false;

    firestore.collection('customers').get().then((value) {
      setState(() {
        value.forEach((doc) {
          customers.add(doc);
        });
      });
    });

    firestore.collection('products').get().then((value) {
      setState(() {
        value.forEach((doc) {
          products.add(doc);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new order'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isEmpty == true
                ? Text(
                    'Please fill in all fields!',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
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
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ).showCursorOnHover,
            RaisedButton(
              child: Text('Place order'),
              onPressed: () {
                if (selectedCustomer != null &&
                    selectedProduct != null &&
                    size.text != "" &&
                    quantity.text != "" &&
                    address.text != "") {
                  firestore.collection('orders').add({
                    'date': DateTime.now(),
                    'customer': selectedCustomer.id,
                    'product': selectedProduct.id,
                    'size': size.text,
                    'quantity': quantity.text,
                    'address': address.text,
                    'status': 'pending',
                  });

                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  setState(() {
                    isEmpty = true;
                  });
                }
              },
            ).showCursorOnHover,
          ],
        ),
      ),
    );
  }
}
