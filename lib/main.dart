import 'package:emotionless/screens/add_orders_screen.dart';
import 'package:emotionless/screens/edit_customers_screen.dart';
import 'package:emotionless/screens/edit_order_screen.dart';
import 'package:emotionless/screens/edit_products_screen.dart';
import 'package:emotionless/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as Firebase;

Future<void> main() async {
  if (Firebase.apps.isEmpty) {
    print(Firebase.apps);
    Firebase.initializeApp(
        apiKey: "AIzaSyA-YXjqbIozh4aqhDbWDmZmDW9sKCw1keQ",
        authDomain: "emotionlesssuriname.firebaseapp.com",
        databaseURL: "https://emotionlesssuriname.firebaseio.com",
        projectId: "emotionlesssuriname",
        storageBucket: "emotionlesssuriname.appspot.com",
        messagingSenderId: "520683933065",
        appId: "1:520683933065:web:35260d193af9a21755e558",
        measurementId: "G-QLPPW457B8");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emotionless',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      onGenerateRoute: (RouteSettings settings) {
        print('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/home': (context) => HomeScreen(),
          '/edit_customer': (context) => EditCustomers(settings.arguments),
          '/edit_product': (context) => EditProducts(settings.arguments),
          '/add_orders': (context) => AddOrders(),
          '/edit_order': (context) => EditOrder(settings.arguments),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}

// firestore.collection('names').add({'text': 'happyharis'}); // create

// firestore.collection('names').doc('111').get(); // read

// firestore
//     .collection('names')
//     .doc('111')
//     .update(data: {'text': 'thehappyharis'}); // update

// firestore.collection('names').doc('7X92XsbOvbnjTfOtKYSr').delete(); // dele
