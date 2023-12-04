import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';
import 'package:firebase_auth_all_feature/helper/dilogs.dart';
import 'package:firebase_auth_all_feature/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is OldUser) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    Dialogs.showProgressBar(context);
                    context.read<AuthBloc>().add(LoginWithGoogle());
                  },
                  child: const Text('Login with Google'),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'email/phone/Username'),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
              controller: _passwordController,
            ),
            const SizedBox(height: 16),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is PasswordWrong) {
                  Dialogs.showSnackBar(context, "Password is wrong");
                } else if (state is UserNotFound) {
                  Dialogs.showSnackBar(context, "User not found");
                } else if (state is LoginSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        Dialogs.showSnackBar(
                            context, "Please enter email and password");
                        return;
                      }
                      context.read<AuthBloc>().add(LoginWithEmailPassword(
                          _emailController.text, _passwordController.text));
                    },
                    child: Text('Login with Username/Password'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
