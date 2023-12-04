import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
        ),
        body: Center(
          child: ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                AuthService.signOut().then((value) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                  );
                });
              }),
        ));
  }
}
