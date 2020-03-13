import 'package:flutter/material.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../extensions/hover_extensions.dart';

class EditColor extends StatefulWidget {
  final DocumentSnapshot ds;

  EditColor(this.ds);

  @override
  _EditColorState createState() => _EditColorState();
}

class _EditColorState extends State<EditColor> {
  final Firestore firestore = fb.firestore();
  TextEditingController colorName = TextEditingController();
  Color pickerColor = Color(0xff443a49);
  Color finalColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

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
                firestore.collection('colors').doc(ds.id).update(data: {
                  'color': colorName.text,
                  'r': pickerColor.red,
                  'b': pickerColor.green,
                  'b': pickerColor.blue,
                  'a': pickerColor.alpha,
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

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
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
                setState(() {
                  finalColor = pickerColor;
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
  void initState() {
    super.initState();
    colorName.text = widget.ds.data()['color'];
    Color clr = Color.fromARGB(
      widget.ds.data()['a'],
      widget.ds.data()['r'],
      widget.ds.data()['g'],
      widget.ds.data()['b'],
    );
    finalColor = clr;
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
            TextField(
              controller: colorName,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            FlatButton(
              child: Text('Pick a color'),
              color: finalColor,
              onPressed: () {
                _showColorPicker();
              },
            ),
            RaisedButton(
              child: Text('Update Color'),
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
