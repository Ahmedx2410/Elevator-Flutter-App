import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test2/homePage.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();
  String _message = '';
  var userData;

  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await usersCollection.doc('admin').get() as DocumentSnapshot<Map<String, dynamic>>;

    return documentSnapshot;
  }

  @override
  void initState() {
    super.initState();
    getUserData().then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      setState(() {
        userData = documentSnapshot.data();
      });
    });
  }

  void _completeLogin() {
    if (userData != null && passCont.text == userData['password'] && emailCont.text == userData['username']) {
      debugPrint("if is True ");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      setState(() {
        _message = 'Invalid username or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextFormField(
              controller: emailCont,
              decoration: InputDecoration(
                  labelText: 'User Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: passCont,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
                height: 40,
                color: Colors.blue,
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    _completeLogin();
                  },
                  child: Text('Login',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                )),
            Column(
              children: [Text(_message)],
            ),
            Column(
              children: [
                Text('Username: ${userData?['username'] ?? ""}'),
                Text('password: ${userData?['password'] ?? ""}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
