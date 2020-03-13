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
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();

  DocumentSnapshot selectedCustomer;
  List<DocumentSnapshot> customers = <DocumentSnapshot>[];

  DocumentSnapshot selectedProduct;
  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  DocumentSnapshot selectedDesign;
  List<DocumentSnapshot> designs = <DocumentSnapshot>[];

  // DocumentSnapshot selectedColor;
  // List<DocumentSnapshot> colors = <DocumentSnapshot>[];

  List<String> sizes = <String>[];
  String selectedSize;

  List<String> quantities = <String>[];
  String selectedQuantity;

  bool newCustomer;

  @override
  void initState() {
    super.initState();

    newCustomer = false;

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

    firestore.collection('designs').get().then((value) {
      setState(() {
        value.forEach((doc) {
          designs.add(doc);
        });
      });
    });

    // firestore.collection('colors').get().then((value) {
    //   setState(() {
    //     value.forEach((doc) {
    //       colors.add(doc);
    //     });
    //   });
    // });

    sizes.add('XS');
    sizes.add('S');
    sizes.add('M');
    sizes.add('L');
    sizes.add('XL');
    sizes.add('XXL');
    sizes.add('2XL');
    sizes.add('3XL');

    for (int i = 0; i < 150; i++) {
      quantities.add((i + 1).toString());
    }
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
            newCustomer == false
                ? DropdownButton<DocumentSnapshot>(
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
                  ).showCursorOnHover
                : Column(
                    children: <Widget>[
                      TextField(
                        controller: firstname,
                        decoration: InputDecoration(hintText: 'Firstname'),
                      ),
                      TextField(
                        controller: lastname,
                        decoration: InputDecoration(hintText: 'Lastname'),
                      ),
                      TextField(
                        controller: mobile,
                        decoration: InputDecoration(hintText: 'Mobile'),
                      ),
                    ],
                  ),
            RaisedButton(
              child: newCustomer == false
                  ? Text('Create new customer')
                  : Text('Cancel creating new customer'),
              onPressed: () {
                setState(() {
                  newCustomer = !newCustomer;
                });
              },
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
                        prod.data()['name'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ).showCursorOnHover,
            DropdownButton<DocumentSnapshot>(
              hint: Text("Select design"),
              value: selectedDesign,
              onChanged: (DocumentSnapshot value) {
                setState(() {
                  selectedDesign = value;
                });
              },
              items: designs.map((DocumentSnapshot design) {
                return DropdownMenuItem<DocumentSnapshot>(
                  value: design,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        design.data()['design'],
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ).showCursorOnHover,
            // DropdownButton<DocumentSnapshot>(
            //   hint: Text("Select color"),
            //   value: selectedColor,
            //   onChanged: (DocumentSnapshot value) {
            //     setState(() {
            //       selectedColor = value;
            //     });
            //   },
            //   items: colors.map((DocumentSnapshot color) {
            //     return DropdownMenuItem<DocumentSnapshot>(
            //       value: color,
            //       child: Row(
            //         children: <Widget>[
            //           SizedBox(
            //             width: 10,
            //           ),
            //           Text(
            //             color.data()['color'],
            //             style: TextStyle(
            //                 color: Color.fromARGB(
            //               color.data()['a'],
            //               color.data()['r'],
            //               color.data()['g'],
            //               color.data()['b'],
            //             )),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            // ).showCursorOnHover,
            DropdownButton<String>(
              hint: Text("Size"),
              value: selectedSize,
              onChanged: (String value) {
                setState(() {
                  selectedSize = value;
                });
              },
              items: sizes.map((String size) {
                return DropdownMenuItem<String>(
                  value: size,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        size,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ).showCursorOnHover,
            DropdownButton<String>(
              hint: Text("Quantity"),
              value: selectedQuantity,
              onChanged: (String value) {
                setState(() {
                  selectedQuantity = value;
                });
              },
              items: quantities.map((String quantity) {
                return DropdownMenuItem<String>(
                  value: quantity,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        quantity,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ).showCursorOnHover,
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
                if (newCustomer == false) {
                  firestore.collection('orders').add({
                    'date': DateTime.now(),
                    'customer': selectedCustomer.id,
                    'product': selectedProduct.id,
                    'design': selectedDesign.id,
                    // 'color': selectedColor.id,
                    'size': selectedSize,
                    'quantity': selectedQuantity,
                    'address': address.text,
                    'status': 'pending',
                  });

                  Navigator.pushReplacementNamed(context, '/home');
                } else if (newCustomer == true) {
                  firestore.collection('customers').add({
                    'firstname': firstname.text,
                    'lastname': lastname.text,
                    'mobile': mobile.text,
                  }).then((customer) {
                    firestore.collection('orders').add({
                      'date': DateTime.now(),
                      'customer': customer.id,
                      'product': selectedProduct.id,
                      'design': selectedDesign.id,
                      // 'color': selectedColor.id,
                      'size': selectedSize,
                      'quantity': selectedQuantity,
                      'address': address.text,
                      'status': 'pending',
                    });
                  });

                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ).showCursorOnHover,
          ],
        ),
      ),
    );
  }
}
