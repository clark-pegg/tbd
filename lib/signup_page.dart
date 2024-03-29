import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tbd/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool passwordVisible1 = false;
  bool passwordVisible2 = false;
  final emailC = TextEditingController();
  final password1C = TextEditingController();
  final password2C = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double textFieldWidth = width * 0.8;
    double textFieldHeight = 50;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Spacer(),
                        const Text(
                          'Create an account',
                          style: TextStyle(fontFamily: 'RobotoMono'),
                          textScaleFactor: 2,
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                            width: textFieldWidth,
                            height: textFieldHeight,
                            child: TextField(
                              controller: emailC,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            )),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: textFieldWidth,
                            height: textFieldHeight,
                            child: TextField(
                              controller: password1C,
                              obscureText: !passwordVisible1,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible1 = !passwordVisible1;
                                        print(passwordVisible1);
                                      },
                                    );
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(height: 30),
                        SizedBox(
                            width: textFieldWidth,
                            height: textFieldHeight,
                            child: TextField(
                              controller: password2C,
                              obscureText: !passwordVisible2,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Confirm Password',
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible2
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible2 = !passwordVisible2;
                                        print(passwordVisible2);
                                      },
                                    );
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: textFieldWidth,
                          height: textFieldHeight,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: DecoratedBox(
                                decoration:
                                    const BoxDecoration(color: Colors.blue),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    _createAccount();
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  void _createAccount() async {
    if (password1C.text == password2C.text) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: password1C.text,
        );
        // FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .collection("notes")
        //     .add({
        //   "name": "My first note",
        // }).then((value) {});
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          final snackBar = SnackBar(
            content: const Text('The password provided is too weak.'),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          final snackBar = SnackBar(
            content: const Text('The account already exists for that email.'),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
