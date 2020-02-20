import 'package:flutter/material.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import '../extensions/hover_extensions.dart';

class EditCustomers extends StatefulWidget {
  final DocumentSnapshot ds;

  EditCustomers(this.ds);

  @override
  _EditCustomersState createState() => _EditCustomersState();
}

class _EditCustomersState extends State<EditCustomers> {
  final Firestore firestore = fb.firestore();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController mobile = TextEditingController();

  void _showConfirmDialog(DocumentSnapshot ds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          // content: Text('This user will be permanently deleted!'),
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
                firestore.collection('customers').doc(ds.id).update(data: {
                  'firstname': firstname.text,
                  'lastname': lastname.text,
                  'mobile': mobile.text,
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
    firstname.text = widget.ds.data()['firstname'];
    lastname.text = widget.ds.data()['lastname'];
    mobile.text = widget.ds.data()['mobile'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            RaisedButton(
              child: Text('Update Customer'),
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
