import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:firebase_auth_all_feature/view/sign_up_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                  child: const Text('Logout'),
                  onPressed: () async {
                    await AuthService.signOut().then((value) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignUpView(),
                        ),
                      );
                    });
                  }),
            ),
          ],
        ));
  }
}
