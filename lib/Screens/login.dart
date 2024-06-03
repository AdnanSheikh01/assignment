// ignore_for_file: use_build_context_synchronously

import 'package:assignment/Components/button.dart';
import 'package:assignment/Components/text_form_field.dart';
import 'package:assignment/Screens/after_sign_up.dart';
import 'package:assignment/Screens/home.dart';
import 'package:assignment/Screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obsecure = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .05),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Lottie.asset('assets/animations/login.json',
                      height: MediaQuery.of(context).size.height / 3),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  callback: (data) {
                    email = data;
                  },
                  labelText: 'Email address',
                  hintText: 'Enter Email',
                  obsecure: false,
                  preIcon: Icons.email,
                  validator: (eml) {
                    if (eml!.isEmpty) {
                      return "Please Enter Email";
                    } else if (!eml.contains('@gmail.com')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  callback: (data) {
                    password = data;
                  },
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  preIcon: Icons.password,
                  obsecure: obsecure,
                  sufIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecure = !obsecure;
                        });
                      },
                      icon: Icon(
                          obsecure ? Icons.visibility_off : Icons.visibility)),
                  validator: (pass) {
                    if (pass!.isEmpty) {
                      return "Please Enter Password";
                    } else if (pass.length < 6) {
                      return "Password must contain Atleast 6 Character";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  icon: CupertinoIcons.arrow_right,
                  label: 'Login',
                  voidCallback: () async {
                    if (_key.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (ctx) => const AlertDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: SizedBox(
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Please Wait...",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        FirebaseAuth.instance.currentUser!.emailVerified
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()))
                            : Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AfterSignupPage(email: email),
                                ),
                              );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red[900],
                              content:
                                  const Text('No user found for that email.')));
                        } else if (e.code == 'wrong-password') {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red[900],
                              content: const Text(
                                  'Wrong password provided for that user.'),
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an Account?"),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
