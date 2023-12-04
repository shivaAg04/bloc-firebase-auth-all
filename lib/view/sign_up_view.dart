import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';

import 'package:firebase_auth_all_feature/view/home_view.dart';
import 'package:firebase_auth_all_feature/view/sign_in_view.dart';
import 'package:firebase_auth_all_feature/view/username_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../bloc/auth.event.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Google Sign-In with Firebase'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OldUser) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ),
              );
            } else if (state is NewUser) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => UserNameView(),
                ),
              );
            }
          },
          child: Column(
            children: [
              Image.asset("assets/images/p.png"),
              const SizedBox(height: 16.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome TO",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " Poll",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                  Text(
                    "Pe.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                ],
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "                                     #EarnKarBefikar",
                    style: TextStyle(color: Colors.grey),
                  )),
              const SizedBox(height: 26.0),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: SignInButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  Buttons.google,
                  text: "Sign up with Google",
                  onPressed: () {
                    context.read<AuthBloc>().add(LoginWithGoogle());
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'OR',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Already have an account?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInView()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color:
                              Colors.purple), // Specify the border color here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the border radius as needed
                      ),
                    ),
                    child: const Text('Sign in'),
                  )),
            ],
          ),
        ));
  }
}
