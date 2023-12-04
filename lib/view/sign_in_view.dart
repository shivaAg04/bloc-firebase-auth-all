import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';
import 'package:firebase_auth_all_feature/helper/dilogs.dart';
import 'package:firebase_auth_all_feature/view/forgetPassword/forget_phone_view.dart';
import 'package:firebase_auth_all_feature/view/home_view.dart';
import 'package:firebase_auth_all_feature/widgets/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/p.png"),
              const SizedBox(height: 16.0),
              const Welcome(),
              const SizedBox(height: 26.0),
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
                  return SizedBox(
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
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Adds a border
                  labelText: 'Email/Username/Phone Number',
                  hintText: 'Enter Email/Username/Phone Number',
                ),
                controller: _emailController,
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Adds a border
                  labelText: 'Password',
                  hintText: 'Password',
                ),
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is PasswordWrong) {
                    Dialogs.showSnackBar(context, "Password is wrong");
                  } else if (state is LoginFailed) {
                    Dialogs.showSnackBar(context, state.error);
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Forget Password?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ForgetPhoneView(),
                        ),
                      );
                    },
                    child: Text('Click here'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
