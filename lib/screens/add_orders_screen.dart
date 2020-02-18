import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

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

  @override
  void initState() {
    super.initState();

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
            ),
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
            ),
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
            ),
            RaisedButton(
              child: Text('Place order'),
              onPressed: () {
                firestore.collection('orders').add({
                  'customer': selectedCustomer.id,
                  'product': selectedProduct.id,
                  'size': size.text,
                  'quantity': quantity.text,
                  'address': address.text,
                  'status': 'pending',
                });

                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
