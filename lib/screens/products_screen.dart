import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import '../extensions/hover_extensions.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Firestore firestore = fb.firestore();
  TextEditingController name = TextEditingController();

  void _showDeleteDialog(DocumentSnapshot ds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This product will be permanently deleted!'),
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
                firestore.collection('products').doc(ds.id).delete();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ).showCursorOnHover,
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new product'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'Name'),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).showCursorOnHover,
            FlatButton(
              child: Text('Add Product'),
              onPressed: () {
                firestore.collection('products').add({
                  'name': name.text,
                });
                Navigator.pop(context);
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
      body: StreamBuilder(
        stream: firestore.collection('products').onSnapshot,
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
                    Icons.spa,
                    color: Colors.black,
                  ),
                  title: Text('${ds.data()['name']}'),
                  trailing: PopupMenuButton(
                    color: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: FlatButton(
                          child: Text('Edit'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/edit_product',
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
                  ).showCursorOnHover,
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ).showCursorOnHover,
    );
  }
}
