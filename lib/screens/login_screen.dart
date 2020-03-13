import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Firestore firestore = fb.firestore();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String name = "";
  String pw = "";

  bool wrongCreds;
  bool success;

  @override
  void initState() {
    super.initState();

    wrongCreds = false;
    success = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text('Login Screen'),
              wrongCreds == true
                  ? Text('Credentials are incorrect!')
                  : Container(),
              TextField(
                controller: username,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              RaisedButton(
                child: success == true
                    ? CircularProgressIndicator()
                    : Text('Login'),
                onPressed: () {
                  setState(() {
                    firestore.collection('login').doc('1').get().then((value) {
                      print(value.data());
                      name = value.data()['username'];
                      pw = value.data()['password'];

                      if (username.text != null || password.text != null) {
                        if (username.text == name && password.text == pw) {
                          setState(() {
                            success = true;
                            Navigator.pushReplacementNamed(context, '/home');
                          });
                        } else {
                          setState(() {
                            wrongCreds = true;
                            success = false;
                          });
                        }
                      }
                    }).catchError((onError) => print(onError));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
