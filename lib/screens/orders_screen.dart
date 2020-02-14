import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Firestore firestore = fb.firestore();

  @override
  void initState() {
    super.initState();

    // firestore.collection('names').add({'text': 'happyharis'}); // create

    // firestore.collection('names').doc('111').get(); // read

    // firestore
    //     .collection('names')
    //     .doc('111')
    //     .update(data: {'text': 'thehappyharis'}); // update

    // firestore.collection('names').doc('7X92XsbOvbnjTfOtKYSr').delete(); // dele
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Orders'),
    );
  }
}
