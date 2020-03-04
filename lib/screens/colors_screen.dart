import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import '../extensions/hover_extensions.dart';

class ColorsScreen extends StatefulWidget {
  @override
  _ColorsScreenState createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  final Firestore firestore = fb.firestore();
  TextEditingController colorName = TextEditingController();

  void _showDeleteDialog(DocumentSnapshot ds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This color will be permanently deleted!'),
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
                firestore.collection('colors').doc(ds.id).delete();
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
          title: Text('Add a new color'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: colorName,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              //TODO: colorpicker goes here!!!
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
              child: Text('Add Color'),
              onPressed: () {
                firestore.collection('colors').add({
                  'color': colorName.text,
                  //TODO: rgb from colorpicker goes here!!!
                  // 'r':
                  // 'g':
                  // 'b':
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
      appBar: AppBar(
        title: Text('Colors'),
      ),
      body: StreamBuilder(
        stream: firestore.collection('colors').onSnapshot,
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
                    Icons.color_lens,
                    color: Color.fromRGBO(
                      ds.data()['r'],
                      ds.data()['g'],
                      ds.data()['b'],
                      1.0,
                    ),
                  ),
                  title: Text('${ds.data()['color']}'),
                  trailing: PopupMenuButton(
                    color: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: FlatButton(
                          child: Text('Edit'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/edit_color', //TODO: create edit color page
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
