import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';
import 'package:firebase_auth_all_feature/view/password_view.dart';
import 'package:firebase_auth_all_feature/view/resetPassword/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgetOtpVerifyView extends StatefulWidget {
  const ForgetOtpVerifyView({super.key});

  @override
  State<ForgetOtpVerifyView> createState() => _ForgetOtpVerifyViewState();
}

class _ForgetOtpVerifyViewState extends State<ForgetOtpVerifyView> {
  final TextEditingController _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OtpVerifyView'),
        ),
        body: Column(
          children: [
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: _otpController,
              
            ),
            SizedBox(height: 16.0),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is OtpVerified) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ResetPasswordView()));
                }
              },
              builder: (context, state) {
                if (state is OtpVerifying) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(VerifyOtp(_otpController.text));
                    },
                    color: Colors.blue,
                    child: Text("Verify"),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
