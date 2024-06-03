import 'dart:async';
import 'package:assignment/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AfterSignupPage extends StatefulWidget {
  const AfterSignupPage({super.key, required this.email});
  final String? email;
  @override
  State<AfterSignupPage> createState() => _AfterSignupPageState();
}

class _AfterSignupPageState extends State<AfterSignupPage> {
  @override
  void initState() {
    sendVerificationEmail();
    super.initState();
  }

  void sendVerificationEmail() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        timer.cancel();
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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .05),
          Center(
            child: Lottie.asset('assets/animations/verify_email_2.json',
                height: MediaQuery.of(context).size.height / 3),
          ),
          const Text(
            'Confirm your email address',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Text(
                  'We send a confirmation link to:',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.email!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Check your email and click on the confirmation link to continue.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            "Didn't recieve confirmation link?",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () {},
              child: const Text(
                'Resend Email',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
