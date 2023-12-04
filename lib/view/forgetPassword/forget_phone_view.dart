import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';
import 'package:firebase_auth_all_feature/view/forgetPassword/forget_otp_verify_view.dart';
import 'package:firebase_auth_all_feature/view/otp_verify_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPhoneView extends StatefulWidget {
  @override
  State<ForgetPhoneView> createState() => _ForgetPhoneViewState();
}

class _ForgetPhoneViewState extends State<ForgetPhoneView> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Phone Number'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  context.read<AuthBloc>().add(CheckPhoneNumberExist(value));
                }),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is ShortPhoneNumber) {
                  return const Text(
                    'Phone number must be at least 10 characters',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (state is PhoneNumberLoading) {
                  return const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator());
                } else if (state is NewPhoneNumber) {
                  return const Text(
                    'Phone number not exist',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (state is OldPhoneNumber) {
                  return const Text(
                    ' Read to verify',
                    style: TextStyle(color: Colors.green),
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 16),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                print(state.toString());
                if (state is PhoneNumberCodeSent) {
                  print("codesent state");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetOtpVerifyView()));
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    context.read<AuthBloc>().verifyPhoneNumber(
                        _phoneNumberController.text.toString());
                  },
                  child: Text('Verify Phone Number'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
