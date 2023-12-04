import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';

import 'package:firebase_auth_all_feature/view/home_view.dart';
import 'package:firebase_auth_all_feature/view/username_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                BlocProvider.of<AuthBloc>(context).add(LoginWithGoogle());
              },
              child: const Text('Sign In with Google'),
            ),
          ),
        ));
  }
}
