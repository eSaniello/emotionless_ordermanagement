import 'package:emotionless/screens/add_orders_screen.dart';
import 'package:emotionless/screens/designs_screen.dart';
// import 'package:emotionless/screens/colors_screen.dart';
// import 'package:emotionless/screens/edit_color_screen.dart';
import 'package:emotionless/screens/edit_customers_screen.dart';
import 'package:emotionless/screens/edit_designs_screen.dart';
import 'package:emotionless/screens/edit_order_screen.dart';
import 'package:emotionless/screens/edit_products_screen.dart';
import 'package:emotionless/screens/home_screen.dart';
import 'package:emotionless/screens/login_screen.dart';
import 'package:emotionless/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as Firebase;

//TODO: Van alle orders wiens status op pending
//staat wil je een soort overzicht hebben van de items die je moet bestellen

//TODO: COMPLETE REDESIGN. (Neumorphism)

//TODO: Add simple hardcoded login

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
        primarySwatch: Colors.blueGrey,
      ),
      // home: LoginScreen(),
      onGenerateRoute: (RouteSettings settings) {
        print('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/': (context) => HomeScreen(),
          '/edit_customer': (context) => EditCustomers(settings.arguments),
          '/edit_product': (context) => EditProducts(settings.arguments),
          '/add_orders': (context) => AddOrders(),
          '/edit_order': (context) => EditOrder(settings.arguments),
          '/designs': (context) => DesignsScreen(),
          '/edit_design': (context) => EditDesigns(settings.arguments),
          // '/colors': (context) => ColorsScreen(),
          // '/edit_color': (context) => EditColor(settings.arguments),
          '/order_details': (context) => OrderDetailsScreen(settings.arguments),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}
