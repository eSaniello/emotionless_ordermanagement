import 'package:emotionless/screens/edit_customers_screen.dart';
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
      title: 'Emotionless',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      onGenerateRoute: (RouteSettings settings) {
        print('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          '/edit_customer': (context) => EditCustomers(settings.arguments),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}
