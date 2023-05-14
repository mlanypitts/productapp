import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      Navigator.of(context).pushNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.antiFlashWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/lottie/splash.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Your products at your doorstep',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

