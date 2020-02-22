import 'package:flutter/material.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import '../extensions/hover_extensions.dart';

class EditDesigns extends StatefulWidget {
  final DocumentSnapshot ds;

  EditDesigns(this.ds);

  @override
  _EditDesignsState createState() => _EditDesignsState();
}

class _EditDesignsState extends State<EditDesigns> {
  final Firestore firestore = fb.firestore();
  TextEditingController design = TextEditingController();

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
                firestore.collection('designs').doc(ds.id).update(data: {
                  'design': design.text,
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
    design.text = widget.ds.data()['design'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Design'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: design,
              decoration: InputDecoration(hintText: 'Design'),
            ),
            RaisedButton(
              child: Text('Update Design'),
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
