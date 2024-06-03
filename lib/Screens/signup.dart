// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:assignment/Components/button.dart';
import 'package:assignment/Components/text_form_field.dart';
import 'package:assignment/Screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'after_sign_up.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obsecure = true;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String cnfpassword = '';
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
                  'Sign Up',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Lottie.asset('assets/animations/signup.json',
                      height: MediaQuery.of(context).size.height / 3),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  callback: (data) {
                    name = data;
                  },
                  labelText: 'Name',
                  hintText: 'Enter Full Name',
                  preIcon: Icons.person,
                  validator: (name) {
                    if (name!.isEmpty) {
                      return "Please Enter your Name";
                    }
                    return null;
                  },
                  obsecure: false,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                    callback: (data) {
                      email = data;
                    },
                    labelText: 'Email address',
                    hintText: 'Enter Email',
                    preIcon: Icons.email,
                    validator: (eml) {
                      if (eml!.isEmpty) {
                        return "Please Enter Email";
                      } else if (!eml.contains('@gmail.com')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    obsecure: false),
                const SizedBox(height: 30),
                CustomTextField(
                  callback: (data) {
                    password = data;
                  },
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  preIcon: Icons.password,
                  validator: (pass) {
                    if (pass!.isEmpty) {
                      return "Please Enter Password";
                    } else if (pass.length < 6) {
                      return "Password must Contain Atleast 6 Character";
                    }
                    return null;
                  },
                  obsecure: obsecure,
                  sufIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecure = !obsecure;
                        });
                      },
                      icon: Icon(
                          obsecure ? Icons.visibility_off : Icons.visibility)),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                    callback: (data) {
                      cnfpassword = data;
                    },
                    labelText: 'Confirm Password',
                    hintText: 'Enter Password',
                    preIcon: Icons.password,
                    validator: (pass) {
                      if (pass!.isEmpty) {
                        return "Please Enter Password";
                      } else if (pass.length < 6) {
                        return "Password must Contain Atleast 6 Character";
                      } else if (cnfpassword != password) {
                        return "Password Doesn't matching";
                      }
                      return null;
                    },
                    obsecure: obsecure),
                const SizedBox(height: 30),
                CustomButton(
                    icon: CupertinoIcons.arrow_right,
                    label: 'Create Account',
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
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AfterSignupPage(email: email),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red[900],
                                content: const Text(
                                    'The password provided is too weak.')));
                          } else if (e.code == 'email-already-in-use') {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red[900],
                                content: const Text(
                                    'The account already exists for that email.')));
                          }
                        } catch (e) {
                          log(e.toString());
                        }
                        // Future.delayed(const Duration(seconds: 3), () {
                        //   Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AfterSignupPage(
                        //         email: email,
                        //       ),
                        //     ),
                        //   );
                        // });
                      }
                    }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account?"),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Login',
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
