import 'package:flutter/material.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import '../extensions/hover_extensions.dart';

class EditProducts extends StatefulWidget {
  final DocumentSnapshot ds;

  EditProducts(this.ds);

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final Firestore firestore = fb.firestore();
  TextEditingController name = TextEditingController();

  void _showConfirmDialog(DocumentSnapshot ds) {
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
                firestore.collection('products').doc(ds.id).update(data: {
                  'name': name.text,
                });
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ).showCursorOnHover,
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.ds.data()['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            RaisedButton(
              child: Text('Update Product'),
              onPressed: () {
                _showConfirmDialog(widget.ds);
              },
            ).showCursorOnHover,
          ],
        ),
      ),
    );
  }
}
