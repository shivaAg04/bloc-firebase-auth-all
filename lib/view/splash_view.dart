// import 'dart:async';

// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Delay for 3 seconds and then navigate to the appropriate screen
//     Timer(
//       Duration(seconds: 3),
//       () {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Splash Screen Example'),
//       ),
//       body: Center(
//         child: Text('Splash Screen Content'),
//       ),
//     );
//   }
// }
