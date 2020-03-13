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
  TextEditingController address = TextEditingController();

  DocumentSnapshot selectedCustomer;
  List<DocumentSnapshot> customers = <DocumentSnapshot>[];

  DocumentSnapshot selectedProduct;
  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  DocumentSnapshot selectedDesign;
  List<DocumentSnapshot> designs = <DocumentSnapshot>[];

  // DocumentSnapshot selectedColor;
  // List<DocumentSnapshot> colors = <DocumentSnapshot>[];

  String selectedStatus;
  List<String> status = <String>[];

  List<String> sizes = <String>[];
  String selectedSize;

  List<String> quantities = <String>[];
  String selectedQuantity;

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

    firestore.collection('designs').get().then((value) {
      setState(() {
        value.forEach((doc) {
          designs.add(doc);
        });

        selectedDesign = designs
            .firstWhere((element) => element.id == widget.order['design'].id);
      });
    });

    // firestore.collection('colors').get().then((value) {
    //   setState(() {
    //     value.forEach((doc) {
    //       colors.add(doc);
    //     });

    //     selectedColor = colors
    //         .firstWhere((element) => element.id == widget.order['color'].id);
    //   });
    // });

    status.add('pending');
    status.add('delivered');
    status.add('ordered');
    selectedStatus =
        status.firstWhere((element) => element == widget.order['status']);

    sizes.add('XS');
    sizes.add('S');
    sizes.add('M');
    sizes.add('L');
    sizes.add('XL');
    sizes.add('XXL');
    sizes.add('2XL');
    sizes.add('3XL');
    selectedSize =
        sizes.firstWhere((element) => element == widget.order['size']);

    for (int i = 0; i < 150; i++) {
      quantities.add((i + 1).toString());
    }
    selectedQuantity =
        quantities.firstWhere((element) => element == widget.order['quantity']);

    address.text = widget.order['address'];
  }

  void _showConfirmDialog(
    String orderId,
    DocumentSnapshot customer,
    DocumentSnapshot product,
    DocumentSnapshot design,
    // DocumentSnapshot color,
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
                  'design': design.id,
                  // 'color': color.id,
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
        title: Text('Edit Color'),
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
            //   hint: Text(
            //     "Select color",
            //     style: TextStyle(
            //       color: selectedColor != null
            //           ? Color.fromARGB(
            //               selectedColor.data()['a'],
            //               selectedColor.data()['r'],
            //               selectedColor.data()['g'],
            //               selectedColor.data()['b'],
            //             )
            //           : Colors.black,
            //     ),
            //   ),
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
                  selectedDesign,
                  // selectedColor,
                  address.text,
                  selectedQuantity,
                  selectedSize,
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
