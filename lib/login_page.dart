import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './signup_page.dart';
import './home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
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
                          'Login',
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
                              obscureText: !passwordVisible,
                              controller: passwordC,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible = !passwordVisible;
                                        print(passwordVisible);
                                      },
                                    );
                                  },
                                ),
                              ),
                            )),
                        SizedBox(
                          width: textFieldWidth,
                          height: textFieldHeight,
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                                text: 'Forgot Password?',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (() => print("I forgor"))),
                          ),
                        ),
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
                                    _loginUser();
                                  },
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: textFieldWidth,
                          height: textFieldHeight,
                          child: Row(children: <Widget>[
                            Expanded(
                                child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: const Divider(
                                color: Colors.grey,
                              ),
                            )),
                            const Text(
                              "OR",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Expanded(
                                child: Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: const Divider(
                                color: Colors.grey,
                              ),
                            )),
                          ]),
                        ),
                        SignInButton(
                          Buttons.Google,
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(
                          width: textFieldWidth,
                          height: textFieldHeight,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "Not a member? ",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Sign up',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (() => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupPage(
                                                    title: "Sign Up Page"),
                                          ),
                                        )),
                                ),
                              ],
                            ),
                          ),
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

  void _loginUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text, password: passwordC.text);
      print(FirebaseAuth.instance.currentUser!.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
